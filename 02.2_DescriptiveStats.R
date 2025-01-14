load(path2temp %+% "02.1_Data4Analysis_out.Rdata") 
#ls()

BDmetrics <- c("N", "N_std","S_obs","S_std","S_n1","S_n2","S_asymp","S_PIE")

############################################################################
### 1. Histograms of Effect sizes
############################################################################
pdf(file=path2temp %+% "Histograms/Hist_EffectSizes.pdf")
for(BD in BDmetrics){
   hist(ES_frag_df[,"ES." %+% BD],main=BD,xlab="ES_frag_df")
   hist(ES_frag_group_df[,"ES." %+% BD],main=BD,xlab="ES_frag_group_df")
   hist(ES_df[,"ES." %+% BD],main=BD,xlab="ES_df")
}
hist(ES_frag_df[,"repl_part_BS_qF"],main="repl_part_BS_qF",xlab="ES_frag_df")
hist(ES_frag_group_df[,"repl_part_BS_qF"],main="repl_part_BS_qF",xlab="ES_frag_group_df")
hist(ES_df[,"repl_part_BS_qF"],main="repl_part_BS_qF",xlab="ES_df")

hist(ES_frag_df[,"repl_part_BS_qT"],main="repl_part_BS_qT",xlab="ES_frag_df")
hist(ES_frag_group_df[,"repl_part_BS_qT"],main="repl_part_BS_qT",xlab="ES_frag_group_df")
hist(ES_df[,"repl_part_BS_qT"],main="repl_part_BS_qT",xlab="ES_df")

dev.off()

############################################################################
### 1. Forest plots
############################################################################

############################################################################
### for each BD metric separately
pdf(file=path2temp %+% "ForestPlots_z.pdf")
sapply(BDmetrics, function(j) forest(x=ES_df.complete[,"ES." %+% j],vi=ES_df.complete[,"ES.var." %+% j],slab=ES_df.complete$Study.ID,psize=1,main=paste(j),cex=.6))
dev.off()       

# ############################################################################
# ### combined forest plot for complete dataset
# png(path2temp %+% "ForestPlots_ES_df.complete_extremes.png",height=40,width=25,units="cm",res=400)
# g_legend<-function(a.gplot){ 
#    tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
#    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
#    legend <- tmp$grobs[[leg]] 
#    return(legend)} 
# 
# ### save legend
# plot1 <- ggplot(data=ES_df.complete_long,aes(y=Case.ID,yend=Case.ID,x=value-1.96*sqrt(ES.var),xend=value+1.96*sqrt(ES.var),color=ES)) + 
#    geom_segment() +
#    geom_point(aes(x=value)) +
#    scale_color_brewer("", palette="Set1",breaks=c("ES.S_obs","ES.D0_hat","ES.N_std","ES.ENS_pie"), labels=c("S_obs","S_asym","N","ENS_PIE"))
# 
# # # if legend from plot1 is drawn
# legend <- g_legend(plot1)
# # png(path2temp %+% "legend.png",height=10,width=10,units="cm",res=200)
# # grid.draw(legend)
# # dev.off()
# 
# pd <- position_dodge(width=0.6)
# plot2 <- ggplot(data=ES_df.complete_long, aes(x=Case.ID,y=value,ymin=value-1.96*sqrt(ES.var),ymax=value+1.96*sqrt(ES.var),color=ES)) + 
#    geom_pointrange(position=pd, cex=0.4,show.legend = F) + 
#    geom_hline(aes(yintercept=0), linetype="twodash",size=0.6) +
#    xlab("") + ylab("") +
#    coord_flip() 
# 
# grid.arrange(plot2,legend, ncol=2, widths=c(15,4))
# dev.off()
# 
# ############################################################################
# ### combined forest plot for complete dataset without extremes of Goodman and Zartman
# png(path2temp %+% "ForestPlots_ES_df.complete_wo_extremes.png",height=40,width=25,units="cm",res=400)
# g_legend<-function(a.gplot){ 
#    tmp <- ggplot_gtable(ggplot_build(a.gplot)) 
#    leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box") 
#    legend <- tmp$grobs[[leg]] 
#    return(legend)} 
# 
# ### save legend
# plot1 <- ggplot(data=ES_df.complete_long,aes(y=Case.ID,yend=Case.ID,x=value-1.96*sqrt(ES.var),xend=value+1.96*sqrt(ES.var),color=ES)) + 
#          geom_segment() +
#          geom_point(aes(x=value)) +
#    scale_color_brewer("", palette="Set1",breaks=c("ES.S_obs","ES.D0_hat","ES.N_std","ES.ENS_pie"), labels=c("S_obs","S_asym","N","ENS_PIE"))
# 
# # # if legend from plot1 is drawn
# legend <- g_legend(plot1)
# # png(path2temp %+% "legend.png",height=10,width=10,units="cm",res=200)
# # grid.draw(legend)
# # dev.off()
# 
# pd <- position_dodge(width=0.6)
# plot2 <- ggplot(data=ES_df.complete_long, aes(x=Case.ID,y=value,ymin=value-1.96*sqrt(ES.var),ymax=value+1.96*sqrt(ES.var),color=ES)) + 
#    geom_pointrange(position=pd, cex=0.4,show.legend = F) + 
#    geom_hline(aes(yintercept=0), linetype="twodash",size=0.6) +
#    ylim(-5,5) +
#    xlab("") + ylab("") +
#    coord_flip() 
# 
# grid.arrange(plot2,legend, ncol=2, widths=c(15,4))
# dev.off()
# 
# ### combined forest plot for frag_group dataset
# png(path2temp %+% "ForestPlots_ES_frag_group_df.png",height=40,width=25,units="cm",res=400)
# ggplot(data=ES_frag_group_df.complete_long,aes(y=Case.ID,x=value,color=ES)) + 
#    geom_point(aes(x=value)) +
#    scale_color_brewer("", palette="Set1",breaks=c("ES.S_obs","ES.D0_hat","ES.N_std","ES.ENS_pie"), labels=c("S_obs","S_asym","N","ENS_PIE"))
# dev.off()
# 
# ### combined forest plot for frag dataset
# png(path2temp %+% "ForestPlots_ES_frag_df.png",height=40,width=25,units="cm",res=400)
# ggplot(data=ES_frag_df.complete_long,aes(y=Case.ID,x=value,color=ES)) + 
#    geom_point(aes(x=value)) +
#    scale_color_brewer("", palette="Set1",breaks=c("ES.S_obs","ES.D0_hat","ES.N_std","ES.ENS_pie"), labels=c("S_obs","S_asym","N","ENS_PIE"))
# dev.off()

############################################################################
### 2. pairwise correlation of effect sizes based on complete observations
############################################################################

## put (absolute) correlations on the upper panels, with background color corresponing to the degree of correlation
panel.cor <- function(x, y, digits = 2, prefix = "", cex.cor=1, ...)
{
   usr <- par("usr"); on.exit(par(usr))
   par(usr = c(0, 1, 0, 1))
   r <- abs(cor(x, y, use="pairwise.complete.obs"))
   palette.vec <- colorRampPalette(colors=c("white","red"))(10)
   col.vec <- palette.vec[r*10]
   txt <- format(c(r, 0.123456789), digits = digits)[1]
   txt <- paste0(prefix, txt)
   if(missing(cex.cor)) cex.cor <- 0.6/strwidth(txt)
   rect(0,0,1,1,col=col.vec)
   text(0.5, 0.5, txt, cex = cex.cor)
}
panel.smooth <- function (x, y, col = par("col"), bg = NA, pch = par("pch"), 
                          cex = 1, col.smooth = "red", span = 2/3, iter = 3, ...) 
{
   points(x, y, pch = pch, col = col, bg = bg, cex = cex)
   ok <- is.finite(x) & is.finite(y)
   if (any(ok)) 
      lines(stats::lowess(x[ok], y[ok], f = span, iter = iter), 
            col = col.smooth, ...)
   abline(0,1,lty="dotted")
}

png(file=path2temp %+% "PairwiseCorPlots/PairwiseCorPlot_frag.png", width=20,height=20,units="cm",res=400,type = "cairo-png")
pairs(ES_frag_df.complete[,c("ES." %+% BDmetrics,"repl_part_BS_qF","repl_part_BS_qT")], labels=c(BDmetrics,"repl_part_S_qF","repl_part_S_qT"),lower.panel = panel.smooth, upper.panel = panel.cor)
dev.off()
png(file=path2temp %+% "PairwiseCorPlots/PairwiseCorPlot_frag_group.png", width=20,height=20,units="cm",res=400,type = "cairo-png")
pairs(ES_frag_group_df.complete[,c("ES." %+% BDmetrics,"repl_part_BS_qF","repl_part_BS_qT")], labels=c(BDmetrics,"repl_part_BS_qF","repl_part_BS_qT"),lower.panel = panel.smooth, upper.panel = panel.cor)
dev.off()
png(file=path2temp %+% "PairwiseCorPlots/PairwiseCorPlot_gradient.png", width=20,height=20,units="cm",res=400,type = "cairo-png")
pairs(ES_df.complete[,c("ES." %+% BDmetrics,"repl_part_BS_qF","repl_part_BS_qT")], labels=c(BDmetrics,"repl_part_BS_qF","repl_part_BS_qT"),lower.panel = panel.smooth, upper.panel = panel.cor)
dev.off()

############################################################################
### 3. Histograms of predictor variables
############################################################################

for(col in c("taxa","country", "continent", "biome", "biome.fragment","biome.matrix", "veg.fragment", "veg.matrix", "matrix.category","time.since.fragmentation","ratio.min.max.fragment.size2")){
   print(col)
   if(col %in% c("taxa","country", "continent", "biome", "biome.fragment","biome.matrix", "veg.fragment", "veg.matrix", "matrix.category","time.since.fragmentation")){
      meta_df[,col] <- factor(meta_df[,col])
      p <- ggplot(data=meta_df) + 
         geom_bar(aes(x=meta_df[,col]), size=0.4,stat="count") + 
         labs(x="",y="") +
         ggtitle(paste(col)) + 
         theme(axis.title = element_text(size = rel(2)), axis.text = element_text(size = rel(2)),plot.title=element_text(size = rel(2)) , axis.text.x=element_text(angle=45,vjust = 1, hjust=1),legend.text=element_text(size = rel(2)),legend.title=element_text(size = rel(2)))
      #,axis.ticks.length=unit(.4,"cm")
   }
   else{    
      p <- ggplot(data=meta_df) + 
         geom_histogram(aes(x=meta_df[,col]), size=0.4,binwidth=0.1) + 
         labs(x="",y="") +
         ggtitle(paste(col)) + 
         theme(axis.title = element_text(size = rel(2)), axis.text = element_text(size = rel(2)),plot.title=element_text(size = rel(2)) , axis.text.x=element_text(angle=45,vjust = 1, hjust=1),legend.text=element_text(size = rel(2)),legend.title=element_text(size = rel(2)))
   #,axis.ticks.length=unit(.4,"cm")
   }
   print(p)
   ggsave(p, file = path2temp %+% "Histograms/Histogram_meta_df_" %+% col %+% ".png", width = 20, height = 8, type = "cairo-png")
   
}

#----- 
# Histograms of sample.design
hist.sample.design <- function(df){
   p <- ggplot(data=df) + 
      geom_bar(aes(x=df$sample_design), size=0.4,stat="count") + 
      labs(x="",y="") +
      ggtitle("sample.design") + 
      theme(axis.title = element_text(size = rel(2)), axis.text = element_text(size = rel(2)),plot.title=element_text(size = rel(2)) , axis.text.x=element_text(angle=45,vjust = 1, hjust=1),legend.text=element_text(size = rel(2)),legend.title=element_text(size = rel(2)))
   #,axis.ticks.length=unit(.4,"cm")
   return(p)
}

p <- hist.sample.design(df=ES_frag_df.complete)
ggsave(p, file = path2temp %+% "Histograms/Histogram_ES_frag_df_sample_design.png", width = 20, height = 8, type = "cairo-png")

p <- hist.sample.design(df=ES_frag_group_df.complete)
ggsave(p, file = path2temp %+% "Histograms/Histogram_ES_frag_group_df_sample_design.png", width = 20, height = 8, type = "cairo-png")

p <- hist.sample.design(df=ES_df.complete)
ggsave(p, file = path2temp %+% "Histograms/Histogram_ES_df_sample_design.png", width = 20, height = 8, type = "cairo-png")
############################################################################
### Crosstables
############################################################################
# with(meta_df,table(biome,taxa))
# with(meta_df,table(matrix.category,taxa))
# with(meta_df,table(time.since.fragmentation,taxa))
# 
# with(meta_df,table(matrix.category,biome))
# with(meta_df,table(time.since.fragmentation,biome))
# 
# with(meta_df,table(time.since.fragmentation,matrix.category))

CrosstabViz.func <- function(var1,var2){
   df <- expand.grid(levels(meta_df[,var1]),levels(meta_df[,var2]))
   df$value <- c(with(meta_df,table(meta_df[,var1],meta_df[,var2])))
   g <- ggplot(df, aes(Var1,Var2)) + 
      geom_point(aes(size = value), colour = "green") + 
      scale_size_continuous(range=c(8,20)) + 
      geom_text(aes(label = value)) +
      ggtitle("Crosstab " %+% var1 %+% " vs. " %+% var2) +
      theme_bw() + theme(axis.text.x=element_text(angle=45,vjust = 1, hjust=1)) + xlab("") + ylab("")
   ggsave(path2temp %+% "Histograms/Crosstab_" %+% var1 %+% "_vs_" %+% var2 %+% ".png")
}

CrosstabViz.func(var1="taxa",var2="biome")
CrosstabViz.func(var1="taxa",var2="matrix.category")
CrosstabViz.func(var1="taxa",var2="time.since.fragmentation")

CrosstabViz.func(var1="biome",var2="matrix.category")
CrosstabViz.func(var1="biome",var2="time.since.fragmentation")

CrosstabViz.func(var1="matrix.category",var2="time.since.fragmentation")

meta_df <- ES_df.complete
var1 <- "time.since.fragmentation"
var2 <- "taxa"
meta_df[,var1] <- factor(meta_df[,var1])
meta_df[,var2] <- factor(meta_df[,var2])

df <- expand.grid(levels(meta_df[,var1]),levels(meta_df[,var2]))
df$value <- c(with(meta_df,table(meta_df[,var1],meta_df[,var2])))
g <- ggplot(df, aes(Var1,Var2)) +
   geom_point(aes(size = value), colour = "green") +
   scale_size_continuous(range=c(8,20)) +
   geom_text(aes(label = value)) +
   ggtitle("Crosstab " %+% var1 %+% " vs. " %+% var2) +
   theme_bw() + theme(axis.text.x=element_text(angle=45,vjust = 1, hjust=1)) + xlab("") + ylab("")
g
ggsave(path2temp %+% "Histograms/Crosstab_ES_df.complete_Time_vs_Taxa.png")

