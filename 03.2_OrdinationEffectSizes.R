# 3. calculate effect sizes per Study.ID and merge with meta-data
source(path2wd %+% "cleanplot.pca.R") 

ES_df <- read.csv(path2temp %+% "ES_df.csv", sep=",")

# PCA following Borcard & Legendre 2011 Numerical Ecology in R pages 118-

str(ES_df)
summary(ES_df)
dim(ES_df)

row.names(ES_df) <- ES_df$Study.ID

# test correlation between no. of fragments and effect sizes
ES_df[ES_df$n.fragment <= 3, ]
plot(tapply(ES_df$z.Pielou_even, ES_df$n.fragment, mean))

# remove variances and NAs
ES_df2 <- ES_df[ES_df$n.fragment > 2, seq(4, 42, by = 2)]
head(ES_df2)

# remove coverages
ES_df2a <- ES_df2[,setdiff(names(ES_df2), c("z.coverage","z.base_cov"))]
ES_df2b <- ES_df2a[complete.cases(ES_df2a), ]
summary(ES_df2b)

ES_pca <- rda(ES_df2b, scale = T)
ES_pca
summary(ES_pca)
summary(ES_pca, scaling = 1)
summary(ES_pca, scaling = "species") #more relevant scaling for relationship
# among variables

?cca.object

# Eigenvalues
(ev <- ES_pca$CA$eig)

# Apply Kaiser-Guttman criterion to select axes
ev[ev > mean(ev)]

# Broken stick model
n <- length(ev)
bsm <- data.frame(j=seq(1:n), p=0)
bsm$p[1] <- 1/n
for (i in 2:n)
{
   bsm$p[i] = bsm$p[i-1] + (1/(n + 1 - i))
}
bsm$p <- 100*bsm$p/n
bsm

## User defined biplot
windows()
biplot(ES_pca, main="PCA - scaling 2", type = c("text", "text"))	# Default scaling = 2


# # Plot eigenvalues and % of variance for each axis
# windows(title="PCA eigenvalues")
# par(mfrow=c(2,1))
# barplot(ev, main="Eigenvalues", col="bisque", las=2)
# abline(h=mean(ev), col="red")		# average eigenvalue
# legend("topright", "Average eigenvalue", lwd=1, col=2, bty="n")
# barplot(t(cbind(100*ev/sum(ev),bsm$p[n:1])), beside=TRUE, 
#         main="% variance", col=c("bisque",2), las=2)
# legend("topright", c("% eigenvalue", "Broken stick model"), 
#        pch=15, col=c("bisque",2), bty="n")


# Two PCA biplots: scaling 1 and scaling 2
# ****************************************

# # Plots using vegan's biplot.rda
# windows(title="PCA biplots - environment - biplot.rda", 12, 6)
# par(mfrow=c(1,2))
# biplot(ES_pca, scaling=1, main="PCA - scaling 1")
# biplot(ES_pca, main="PCA - scaling 2")	# Default scaling = 2
# 
# # Plots using cleanplot.pca()
# # A rectangular graphic window is needed for the two plots
# windows(title="PCA biplots - environment - cleanplot.pca", 12, 6)
# cleanplot.pca(ES_pca)							# with site labels only (vegan's standard)
# cleanplot.pca(ES_pca, point=TRUE)	# with points for sites and arrowheads
# cleanplot.pca(ES_pca, ahead=0)			# ... and without arrowheads
# 
# # User defined biplot
# windows()
# biplot(ES_pca, main="PCA - scaling 2", type = c("text", "points"))	# Default scaling = 2
# 
# pairs(ES_df2b)

