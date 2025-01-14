# plot results of fragment level beta-diversity
library(tidyverse)
library(brms)
library(ggridges)

load('~/Dropbox/1current/fragmentation_synthesis/results/Jtu_z1i_frag_beta-5098650.Rdata')
load('~/Dropbox/1current/fragmentation_synthesis/results/Rtu_z1i_frag_beta-5098692.Rdata')

load('~/Dropbox/1current/fragmentation_synthesis/results/Jne_zi_fragSize.Rdata')
load('~/Dropbox/1current/fragmentation_synthesis/results/Rne_zi_fragSize.Rdata')

frag_beta <- read_csv('~/Dropbox/Frag Database (new)/files_datapaper/Analysis/2_betapart_frag_fcont_10_mabund_as_is.csv')

# get the metadata
meta <- read.csv('~/Dropbox/Frag Database (new)/new_meta_2_merge.csv', sep=';') %>% 
  as_tibble() %>% 
  dplyr::rename(dataset_label = dataset_id)

frag_beta <- frag_beta %>% 
  group_by(dataset_label, sample_design, method, frag_x) %>% 
  mutate(pair_group = paste0(frag_x, '_g')) %>% 
  ungroup() %>% 
  # centre covariate before fitting
  mutate(cl10ra = log10_ratio_area - mean(log10_ratio_area))

frag_beta <- left_join(frag_beta, 
                       meta, by = 'dataset_label')


#------wrangle for plotting
# for plotting fixed effects----------------
Jtu_z1i_fitted <- cbind(Jtu_z1i_fragSize$data,
                         fitted(Jtu_z1i_fragSize, re_formula = NA, scale = 'linear')) %>%
  as_tibble() %>% 
  left_join(frag_beta %>% 
               mutate(cl10ra = log10_ratio_area - mean(log10_ratio_area)) %>% 
               distinct(dataset_label, pair_group, cl10ra, frag_size_num.x, frag_size_num.y, log10_ratio_area),
             by = c('dataset_label', 'pair_group', 'cl10ra')) %>% 
  # want the 'fitted' values of the coi component too
  bind_cols(
    fitted(Jtu_z1i_fragSize, re_formula = NA, dpar = 'coi', scale = 'linear') %>% 
      as_tibble() %>% 
      mutate(coi_Estimate = Estimate,
             coi_Q2.5 = Q2.5,
             coi_Q97.5 = Q97.5) %>% 
      select(coi_Estimate, coi_Q2.5, coi_Q97.5))


Jtu_z1i_fixef <- fixef(Jtu_z1i_fragSize)
# random effects
Jtu_z1i_coef <- coef(Jtu_z1i_fragSize)

Jtu_z1i_group_coefs <- bind_cols(Jtu_z1i_coef[[1]][,,'Intercept'] %>% 
                                                  as_tibble() %>% 
                                                  mutate(Intercept = Estimate,
                                                         Intercept_lower = Q2.5,
                                                         Intercept_upper = Q97.5,
                                                         dataset_label = rownames(Jtu_z1i_coef[[1]][,,'Intercept'])) %>% 
                                                  dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5),
                                 Jtu_z1i_coef[[1]][,,'cl10ra'] %>% 
                                                  as_tibble() %>% 
                                                  mutate(Slope = Estimate,
                                                         Slope_lower = Q2.5,
                                                         Slope_upper = Q97.5) %>% 
                                                  dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5)) %>% 
  # join with min and max of the x-values
  inner_join(frag_beta %>% 
               group_by(dataset_label) %>% 
               summarise(xmin.x = min(frag_size_num.x),
                         xmax.x = max(frag_size_num.x),
                         xmin.y = min(frag_size_num.y),
                         xmax.y = max(frag_size_num.y),
                         cxmin = min(cl10ra),
                         cxmax = max(cl10ra)),
             by = 'dataset_label')

# repeat for Ruzicka
Rtu_z1i_fitted <- cbind(Rtu_z1i_fragSize$data,
                        fitted(Rtu_z1i_fragSize, re_formula = NA, scale = 'linear')) %>%
  as_tibble() %>% 
  left_join(frag_beta %>% 
              mutate(cl10ra = log10_ratio_area - mean(log10_ratio_area)) %>% 
              distinct(dataset_label, pair_group, cl10ra, frag_size_num.x, frag_size_num.y, log10_ratio_area),
            by = c('dataset_label', 'pair_group', 'cl10ra')) %>% 
  # want the 'fitted' values of the coi component too
  bind_cols(
    fitted(Rtu_z1i_fragSize, re_formula = NA, dpar = 'coi', scale = 'linear') %>% 
      as_tibble() %>% 
      mutate(coi_Estimate = Estimate,
             coi_Q2.5 = Q2.5,
             coi_Q97.5 = Q97.5) %>% 
      select(coi_Estimate, coi_Q2.5, coi_Q97.5))


Rtu_z1i_fixef <- fixef(Rtu_z1i_fragSize)

Rtu_z1i_coef <- coef(Rtu_z1i_fragSize)

Rtu_z1i_group_coefs <- bind_cols(Rtu_z1i_coef[[1]][,,'Intercept'] %>% 
                                   as_tibble() %>% 
                                   mutate(Intercept = Estimate,
                                          Intercept_lower = Q2.5,
                                          Intercept_upper = Q97.5,
                                          dataset_label = rownames(Rtu_z1i_coef[[1]][,,'Intercept'])) %>% 
                                   dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5),
                                 Rtu_z1i_coef[[1]][,,'cl10ra'] %>% 
                                   as_tibble() %>% 
                                   mutate(Slope = Estimate,
                                          Slope_lower = Q2.5,
                                          Slope_upper = Q97.5) %>% 
                                   dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5)) %>% 
  # join with min and max of the x-values
  inner_join(frag_beta %>% 
               group_by(dataset_label) %>% 
               summarise(xmin.x = min(frag_size_num.x),
                         xmax.x = max(frag_size_num.x),
                         xmin.y = min(frag_size_num.y),
                         xmax.y = max(frag_size_num.y),
                         cxmin = min(cl10ra),
                         cxmax = max(cl10ra)),
             by = 'dataset_label')

# now for the nestedness components
Jne_zi_fitted <- cbind(Jne_zi_fragSize$data,
                        fitted(Jne_zi_fragSize, re_formula = NA, scale = 'linear')) %>%
  as_tibble() %>% 
  left_join(frag_beta %>% 
              mutate(cl10ra = log10_ratio_area - mean(log10_ratio_area)) %>% 
              distinct(dataset_label, pair_group, cl10ra, frag_size_num.x, frag_size_num.y, log10_ratio_area),
            by = c('dataset_label', 'pair_group', 'cl10ra')) %>% 
  # want the 'fitted' values of the coi component too
  bind_cols(
    fitted(Jne_zi_fragSize, re_formula = NA, dpar = 'zi', scale = 'linear') %>% 
      as_tibble() %>% 
      mutate(zi_Estimate = Estimate,
             zi_Q2.5 = Q2.5,
             zi_Q97.5 = Q97.5) %>% 
      select(zi_Estimate, zi_Q2.5, zi_Q97.5))


Jne_zi_fixef <- fixef(Jne_zi_fragSize)
# random effects
Jne_zi_coef <- coef(Jne_zi_fragSize)

Jne_zi_group_coefs <- bind_cols(Jne_zi_coef[[1]][,,'Intercept'] %>% 
                                   as_tibble() %>% 
                                   mutate(Intercept = Estimate,
                                          Intercept_lower = Q2.5,
                                          Intercept_upper = Q97.5,
                                          dataset_label = rownames(Jne_zi_coef[[1]][,,'Intercept'])) %>% 
                                   dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5),
                                 Jne_zi_coef[[1]][,,'cl10ra'] %>% 
                                   as_tibble() %>% 
                                   mutate(Slope = Estimate,
                                          Slope_lower = Q2.5,
                                          Slope_upper = Q97.5) %>% 
                                   dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5)) %>% 
  # join with min and max of the x-values
  inner_join(frag_beta %>% 
               filter(method == 'Baselga family, Jaccard') %>% 
               group_by(dataset_label) %>% 
               summarise(xmin.x = min(frag_size_num.x),
                         xmax.x = max(frag_size_num.x),
                         xmin.y = min(frag_size_num.y),
                         xmax.y = max(frag_size_num.y),
                         cxmin = min(cl10ra),
                         cxmax = max(cl10ra)),
             by = 'dataset_label')

# repeat for Ruzicka
Rne_zi_fitted <- cbind(Rne_zi_fragSize$data,
                        fitted(Rne_zi_fragSize, re_formula = NA, scale = 'linear')) %>%
  as_tibble() %>% 
  left_join(frag_beta %>% 
              mutate(cl10ra = log10_ratio_area - mean(log10_ratio_area)) %>% 
              distinct(dataset_label, pair_group, cl10ra, frag_size_num.x, frag_size_num.y, log10_ratio_area),
            by = c('dataset_label', 'pair_group', 'cl10ra')) %>% 
  # want the 'fitted' values of the coi component too
  bind_cols(
    fitted(Rne_zi_fragSize, re_formula = NA, dpar = 'zi', scale = 'linear') %>% 
      as_tibble() %>% 
      mutate(zi_Estimate = Estimate,
             zi_Q2.5 = Q2.5,
             zi_Q97.5 = Q97.5) %>% 
      select(zi_Estimate, zi_Q2.5, zi_Q97.5))


Rne_zi_fixef <- fixef(Rne_zi_fragSize)

Rne_zi_coef <- coef(Rne_zi_fragSize)

Rne_zi_group_coefs <- bind_cols(Rne_zi_coef[[1]][,,'Intercept'] %>% 
                                   as_tibble() %>% 
                                   mutate(Intercept = Estimate,
                                          Intercept_lower = Q2.5,
                                          Intercept_upper = Q97.5,
                                          dataset_label = rownames(Rne_zi_coef[[1]][,,'Intercept'])) %>% 
                                   dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5),
                                 Rne_zi_coef[[1]][,,'cl10ra'] %>% 
                                   as_tibble() %>% 
                                   mutate(Slope = Estimate,
                                          Slope_lower = Q2.5,
                                          Slope_upper = Q97.5) %>% 
                                   dplyr::select(-Estimate, -Est.Error, -Q2.5, -Q97.5)) %>% 
  # join with min and max of the x-values
  inner_join(frag_beta %>% 
               group_by(dataset_label) %>% 
               summarise(xmin.x = min(frag_size_num.x),
                         xmax.x = max(frag_size_num.x),
                         xmin.y = min(frag_size_num.y),
                         xmax.y = max(frag_size_num.y),
                         cxmin = min(cl10ra),
                         cxmax = max(cl10ra)),
             by = 'dataset_label')

##--------now plot the regressions----------------
turnover_regression <- ggplot() +
  # data
  geom_point(data = frag_beta %>% filter(method == 'Baselga family, Jaccard'),
             aes(x = frag_size_num.x/frag_size_num.y, y = repl, colour = dataset_label),
             size = 0.25,
             alpha = 0.15) +
  geom_segment(data = Jtu_z1i_group_coefs,
               aes(group = dataset_label,
                   colour = dataset_label,
                   x = xmin.x/xmin.y,
                   # trick: max x-value requires a min in the denominator 
                   xend = xmax.x/xmin.y,
                   y = plogis(Intercept + Slope * cxmin),
                   yend = plogis(Intercept + Slope * cxmax)),
               size = 0.5) +
  # fixed effect
  geom_line(data = Jtu_z1i_fitted, 
            aes(x = frag_size_num.x/frag_size_num.y,
                y = plogis(Estimate)),
            size = 1.5) +
  # fixed effect for Ruzicka
  geom_line(data = Rtu_z1i_fitted,
            aes(x = frag_size_num.x/frag_size_num.y,
                y = plogis(Estimate)),
            size = 1, lty = 3) +
  # fixed effect uncertainty
  geom_ribbon(data = Jtu_z1i_fitted,
              aes(x = frag_size_num.x/frag_size_num.y,
                  ymin = plogis(Q2.5),
                  ymax = plogis(Q97.5)),
              alpha = 0.3) +
  # fixed effect uncertainty: Ruzicka
  geom_ribbon(data = Rtu_z1i_fitted,
              aes(x = frag_size_num.x/frag_size_num.y,
                  ymin = plogis(Q2.5),
                  ymax = plogis(Q97.5)),
              alpha = 0.3) +
  # conditional probability of being one (given bernoulli mix)
  # geom_line(data = Jtu_z1i_fitted, 
  #           aes(x = frag_size_num.x/frag_size_num.y,
  #               y = plogis(coi_Estimate)),
  #           size = 1.5) +
  # geom_ribbon(data = Jtu_z1i_fitted,
  #             aes(x = frag_size_num.x/frag_size_num.y,
  #                 ymin = plogis(coi_Q2.5),
  #                 ymax = plogis(coi_Q97.5)),
  #             alpha = 0.3) +
  # add regression coefficient and uncertainty interval
annotate('text', x = 10^3.5, y = 0.95,
           label = paste("beta[Jtu] == ", #[Frag.~size]
                         round(Jtu_z1i_fixef['cl10ra','Estimate'],2),
                         "  (",
                         round(Jtu_z1i_fixef['cl10ra','Q2.5'],2),
                         " - ",
                         round(Jtu_z1i_fixef['cl10ra','Q97.5'],2),
                         ")"),
           parse = T) +
  annotate('text', x = 10^3.5, y = 0.9,
           label = paste("beta[Rbal] == ", #[Frag.~size]
                         round(Rtu_z1i_fixef['cl10ra','Estimate'],2),
                         "  (",
                         round(Rtu_z1i_fixef['cl10ra','Q2.5'],2),
                         " - ",
                         round(Rtu_z1i_fixef['cl10ra','Q97.5'],2),
                         ")"),
           parse = T) +
  scale_x_log10(breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  # scale_y_continuous(trans = 'log', breaks = c(4,16, 32,64,128, 256)) +
  scale_colour_viridis_d(guide=F) +
  labs(x = 'Ratio of fragment sizes (log-scale)',
       y = 'Turnover') +
  theme_bw() +
  theme(legend.position = 'none')

nestedness_regression <- ggplot() +
  # data
  geom_point(data = frag_beta %>% filter(method == 'Baselga family, Jaccard'),
             aes(x = frag_size_num.x/frag_size_num.y, y = rich, colour = dataset_label),
             size = 0.25,
             alpha = 0.15) +
  geom_segment(data = Jne_zi_group_coefs,
               aes(group = dataset_label,
                   colour = dataset_label,
                   x = xmin.x/xmin.y,
                   xend = xmax.x/xmin.y,
                   y = plogis(Intercept + Slope * cxmin),
                   yend = plogis(Intercept + Slope * cxmax)),
               size = 0.5) +
  # fixed effect
  geom_line(data = Jne_zi_fitted, 
            aes(x = frag_size_num.x/frag_size_num.y,
                y = plogis(Estimate)),
            size = 1.5) +
  # fixed effect
  geom_line(data = Rne_zi_fitted,
            aes(x = frag_size_num.x/frag_size_num.y,
                y = plogis(Estimate)),
            size = 1, lty = 3) +
  # fixed effect uncertainty
  geom_ribbon(data = Jne_zi_fitted,
              aes(x = frag_size_num.x/frag_size_num.y,
                  ymin = plogis(Q2.5),
                  ymax = plogis(Q97.5)),
              alpha = 0.3) +
  # fixed effect uncertainty: Ruzicka
  geom_ribbon(data = Rne_zi_fitted,
              aes(x = frag_size_num.x/frag_size_num.y,
                  ymin = plogis(Q2.5),
                  ymax = plogis(Q97.5)),
              alpha = 0.3) +
  # conditional probability of being one (given bernoulli mix)
  # geom_line(data = Jtu_z1i_fitted, 
  #           aes(x = frag_size_num.x/frag_size_num.y,
  #               y = plogis(coi_Estimate)),
  #           size = 1.5) +
  # geom_ribbon(data = Jtu_z1i_fitted,
  #             aes(x = frag_size_num.x/frag_size_num.y,
  #                 ymin = plogis(coi_Q2.5),
  #                 ymax = plogis(coi_Q97.5)),
  #             alpha = 0.3) +
  # add regression coefficient and uncertainty interval
annotate('text', x = 10^3.5, y = 0.95,
         label = paste("beta[Jne] == ", #[Frag.~size]
                       round(Jne_zi_fixef['cl10ra','Estimate'],2),
                       "  (",
                       round(Jne_zi_fixef['cl10ra','Q2.5'],2),
                       " - ",
                       round(Jne_zi_fixef['cl10ra','Q97.5'],2),
                       ")"),
         parse = T) +
  annotate('text', x = 10^3.5, y = 0.9,
           label = paste("beta[Rgrad] == ", #[Frag.~size]
                         round(Rne_zi_fixef['cl10ra','Estimate'],2),
                         "  (",
                         round(Rne_zi_fixef['cl10ra','Q2.5'],2),
                         " - ",
                         round(Rne_zi_fixef['cl10ra','Q97.5'],2),
                         ")"),
           parse = T) +
  scale_x_log10(breaks = scales::trans_breaks("log10", function(x) 10^x),
              labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  # scale_y_continuous(trans = 'log', breaks = c(4,16, 32,64,128, 256)) +
  scale_colour_viridis_d(guide=F) +
  labs(x = 'Ratio of fragment sizes (log-scale)',
       y = 'Nestedness') +
  coord_cartesian(ylim = c(0,1)) +
  theme_bw() +
  theme(legend.position = 'none')

cowplot::plot_grid(turnover_regression, 
                   nestedness_regression, nrow = 1)

# ggsave('~/Dropbox/1current/fragmentation_synthesis/results/figures/results/beta_frag.png', width = 250, height = 125, units = 'mm')

hist(Jtu_z1i_group_coefs$Slope)
hist(Jne_zi_group_coefs$Slope)
