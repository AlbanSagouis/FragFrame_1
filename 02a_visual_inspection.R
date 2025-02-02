# visual inspection of data for fragmentation synthesis

# Please do not use absolute paths in a shared R script! Please adjust 00_InitializeDirectories_LoadPackages.R
# frag <- read_csv('~/Dropbox/Habitat loss meta-analysis/analysis/diversity_metadata.csv')

frag <- read_csv(paste(path2temp, "diversity_metadata.csv", sep = ""))

# setwd('~/Dropbox/Habitat loss meta-analysis/analysis/figs/visual_inspection/')
setwd(paste(path2temp,"figs/visual_inspection/", sep = ""))

# we are mostly interested in diversity as a function of entity size
# the different standardisation look qualitativley similar, though S_cov has a lower intercept
ggplot() +
  geom_point(data = frag,
             aes(x = entity.size, y = S_n, colour = 'S_n'),
             alpha = 0.5) +
  geom_point(data = frag,
             aes(x = entity.size, y = S_cov, colour = 'S_cov'),
             alpha = 0.5) +
  geom_point(data = frag,
             aes(x = entity.size, y = S_std, colour = 'S_std'),
             alpha = 0.5) +
  stat_smooth(data = frag,
              method = 'lm',
              aes(x = entity.size, y = S_n),
              colour = 'black') +
  stat_smooth(data = frag,
              method = 'lm',
              aes(x = entity.size, y = S_cov),
              colour = 'red') +
  stat_smooth(data = frag,
              method = 'lm',
              aes(x = entity.size, y = S_std),
              colour = 'blue') +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(2,32,64,128, 256)) +
  scale_colour_manual(name = '',
                      values = c('S_n' = 'black', 'S_cov' = 'red', 'S_std' = 'blue')) +
  labs(x = 'Fragment size (hectares)',
       y = 'Richness (standardised)') +
  theme_bw() #+
  #theme(legend.position = c(0.1,0.9))

ggsave('standardised_S_fragmentSize.pdf', width = 290, height = 200, units = 'mm')

# S_PIE?
ggplot() +
  geom_point(data = frag,
             aes(x = entity.size, y = S_PIE),
             alpha = 0.5) +
  stat_smooth(data = frag,
              method = 'lm',
              aes(x = entity.size, y = S_PIE),
              colour = 'black') +
  # add study-level variation
  # stat_smooth(data = frag,
  #             method = 'lm', se=F,
  #             aes(x = entity.size, y = S_PIE, group = filename, colour = taxa),
  #             lwd = 1/2) +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2') +
  scale_colour_viridis_d(name = 'Taxa') +
  labs(x = 'Fragment size (ha)',
       y = expression(S[PIE])) +
  theme_bw() #+
  #theme(legend.position = c(0.1,0.8))

ggsave('S_PIE_fragmentSize.pdf', width = 290, height = 200, units = 'mm')

# Total and standardized N
ggplot() +
   geom_point(data = frag,
              aes(x = entity.size, y = N, colour = 'N'),
              alpha = 0.5) +
   geom_point(data = frag,
              aes(x = entity.size, y = N_std, colour = 'N_std'),
              alpha = 0.5) +
   stat_smooth(data = frag,
               method = 'lm',
               aes(x = entity.size, y = N),
               colour = 'black') +
   stat_smooth(data = frag,
               method = 'lm',
               aes(x = entity.size, y = N_std),
               colour = 'red') +
   scale_x_continuous(trans = 'log10') +
   scale_y_continuous(trans = 'log10') +
   scale_colour_manual(name = '',
                       values = c('N' = 'black', 'N_std' = 'red')) +
   labs(x = 'Fragment size (hectares)',
        y = 'No. of individuals') +
   theme_bw() 
   
ggsave('N_fragmentSize.pdf', width = 290, height = 200, units = 'mm')


# what does the study-level variation look like?
ggplot() +
  geom_point(data = frag,
             aes(x = entity.size, y = S_n)) +
  stat_smooth(data = frag,
              method = 'lm',
              aes(x = entity.size, y = S_n),
              colour = 'black') +
  stat_smooth(data = frag,
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n,
                  group = filename),
              colour = 'black', lwd = 0.3) +
  scale_colour_viridis_d(name = 'Taxa') +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(4,32,64,128,256)) +
  labs(x = 'Fragment size (hectares)',
       y = expression(paste(S[n]))) +
  theme_bw() +
  theme(legend.position = c(0.1, 0.9))

# ggsave('S_n_fragmentSize_studyLevel.pdf', width = 290, height = 200, units = 'mm')

# How do we want to examine taxa? Within studies, or across all studies?
# are there really studies where we don't know the taxa? Jon will check NAs here...
# this plot is taxa across all studies...
ggplot() +
  geom_point(data = frag,
             aes(x = entity.size, y = S_n, 
                 colour = taxa),
             alpha = 0.3) +
  stat_smooth(data = frag,
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n, 
                  colour = taxa)) +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(2,32,64,128,256)) +
  scale_colour_viridis_d(name = 'Taxa') +
  theme_bw() +
  theme(legend.position = c(0.1, 0.9))

#....but I think we should allow the taxa to vary within studies too:
ggplot() +
  geom_point(data = frag,
             aes(x = entity.size, y = S_n, 
                 colour = taxa), 
             alpha = 0.3, size = 1.5) +
  stat_smooth(data = frag,
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n,
                  colour = taxa),
              size = 1.5) +
  stat_smooth(data = frag,
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n, group = filename,
                  colour = taxa),
              size = 0.3) +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(2,32,64,128, 256)) +
  scale_colour_viridis_d(name = 'Taxa') +
  labs(x = 'Fragment size (hectares)',
       y = expression(paste(S[n]))) +
  theme_bw() +
  theme(legend.position = c(0.1, 0.8),
        legend.background = element_blank())

# ggsave('standardised_S_fragmentSize_x_taxa_studyLevel.pdf', width = 290, height = 200, units = 'mm')

# taxa may respond differently depending on the vegetation within the fragments
ggplot() +
  facet_wrap(~veg.fragment) +
  # throw out the fragments for which we don't have veg.fragment data
  geom_point(data = frag %>% filter(!is.na(veg.fragment)),
             aes(x = entity.size, y = S_n, 
                 colour = taxa)) +
  stat_smooth(data = frag %>% filter(!is.na(veg.fragment)),
              method = 'lm',
              aes(x = entity.size, y = S_n),
              colour = 'black') +
  stat_smooth(data = frag %>% filter(!is.na(veg.fragment)),
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n, group = filename,
                  colour = taxa),
              lwd = 0.3) +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(2,32,64,128, 256)) +
  scale_colour_viridis_d(name = 'Taxa') +
  labs(x = 'Fragment size (hectares)',
       y = expression(paste(S[n]))) +
  theme_bw() +
  theme(legend.position = c(0.9, 0.9),
        legend.background = element_blank())

# ggsave('Sn_fragmentSize_x_taxa_x_vegFragment_studyLevel.pdf', width = 290, height = 200, units = 'mm')

# what about the character of the matrix?
# add factor for ordering facets
frag$f.matrix.category <- factor(frag$matrix.category, levels = c('light filter', 'medium filter', 'harsh filter')) 

ggplot() +
  facet_wrap(~f.matrix.category) +
  # throw out the fragments for which we don't have matrix.category data
  geom_point(data = frag %>% filter(!is.na(matrix.category)),
             aes(x = entity.size, y = S_n, 
                 colour = taxa)) +
  stat_smooth(data = frag %>% filter(!is.na(matrix.category)),
              method = 'lm',
              aes(x = entity.size, y = S_n),
              colour = 'black') +
  stat_smooth(data = frag %>% filter(!is.na(matrix.category)),
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n, group = filename,
                  colour = taxa),
              lwd = 0.3) +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(2,32,64,128, 256)) +
  scale_colour_viridis_d(name = 'Taxa') +
  labs(x = 'Fragment size (hectares)',
       y = expression(paste(S[n]))) +
  theme_bw() +
  theme(legend.position = c(0.1, 0.8),
        legend.background = element_blank())

# ggsave('Sn_fragmentSize_x_taxa_x_matrixCategory_studyLevel.pdf', width = 290, height = 140, units = 'mm')

# time since fragmentation
# order for facets...
frag$f.tsf <- factor(frag$time.since.fragmentation, 
                     levels = c('recent (less than 20 years)', 'intermediate (20-100 years)', 'long (100+ years)'))
# long time since fragmentation has an overall negative slope...
ggplot() +
  facet_wrap(~f.tsf) +
  # throw out the fragments for which we don't have matrix.category data
  geom_point(data = frag %>% filter(!is.na(time.since.fragmentation)),
             aes(x = entity.size, y = S_n, 
                 colour = taxa)) +
  stat_smooth(data = frag %>% filter(!is.na(time.since.fragmentation)),
              method = 'lm',
              aes(x = entity.size, y = S_n),
              colour = 'black') +
  stat_smooth(data = frag %>% filter(!is.na(time.since.fragmentation)),
              method = 'lm', se = F,
              aes(x = entity.size, y = S_n, group = filename,
                  colour = taxa),
              lwd = 0.3) +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log2', breaks = c(2,32,64,128, 256)) +
  scale_colour_viridis_d(name = 'Taxa') +
  labs(x = 'Fragment size (hectares)',
       y = expression(paste(S[n]))) +
  theme_bw() +
  theme(legend.position = c(0.15, 0.9),
        legend.background = element_blank()) +
  guides(colour = guide_legend(ncol = 2))

# ggsave('Sn_fragmentSize_x_taxa_x_timeSinceFrag_studyLevel.pdf', width = 290, height = 140, units = 'mm')