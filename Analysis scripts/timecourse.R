options(stringsAsFactors=FALSE)
library(gplots)

# If the user desires, they can limit the repetitions of the gene expression profiles.  Here, there is a 
# short excerpt that will take just a single instance of each promoter.  Keeping all 6144 colonies in the clustering
# though is still an option
compressGenes <- function(dataIn) {
	unq <- unique(genes)
	for(ii in 1:length(unq)) {
		active <- which(genes==unq[ii])
		# meanDat <- t(as.matrix(apply(dataIn[active,],2,function(x) mean(x,na.rm=TRUE))))
		maxTemp <- apply(dataIn[active,],1,function(x) max(x,na.rm=TRUE))
		meanDat <- dataIn[active[which(maxTemp==max(maxTemp))[1]],]

		dOut <- meanDat
		# dOut2 <- sdDat
		if(ii==1) {
			repsOut <- dOut
			# repsOutSD <- dOut2
		} else {
			repsOut <- rbind(repsOut,dOut)
			# repsOutSD <- rbind(repsOutSD,dOut2)
		}
	}
	return(repsOut)
}

# Be sure to set the working directory to wherever these files are located using 'setwd()' if not opening
# R from the terminal window that is already in the correct directory

# Load legend
legendGFP <- read.csv("legend.txt",sep="\t",header=TRUE)
genes <- legendGFP[,1]
unq <- unique(genes)
empty <- which(legendGFP[,1]=="Empty")
pua66 <- which(legendGFP[,1]=="U66" | legendGFP[,1]=="U139")

# Load the 'gfpData.Rdata' files that is exported from the analysisCode.R script
load('gfpData.Rdata')

# Load the library needed for clustering and such.  If it doesn't exist, follow the instructions here:
# https://www.bioconductor.org/install/ to install Bioconductor, then the instructions here:
# https://www.bioconductor.org/packages/release/bioc/html/Mfuzz.html
# to install the Mfuzz package.
library(Mfuzz)

# Subset just the promoter activity
promoter.activity.working <- gfpData[[1]]$promoter.activity
promoter.activity.sum <- apply(promoter.activity.working,1,sum)
# If user doesn't want to use all the promoters, use the compressGenes function to just take a single instance
# promoter.activity <- compressGenes(promoter.activity.working)
# rownames(promoter.activity) <- unq

promoter.activity <- promoter.activity.working
# If the user is only taking a single instance of the promoters using the compressGenes function, comment out
# the following line, as the rows will have already been named
rownames(promoter.activity) <- make.unique(genes)

# Define the timepoints here, defaulting for 18 hours of growth, sampling every 5 minutes.  User will need to modify
timepoints <- (seq(0,(216)*5,by=5))/60
promoter.activity <- na.omit(promoter.activity)
t4set <- new("ExpressionSet",exprs=promoter.activity)
filteredVals <- filter.std(t4set,min.std=0)
filteredVals.standardized <- standardise(filteredVals)

# Create clusters, here set at 12, for how to explain the data.  More clusters can lead to curves closer in similarity
# clustering together, but we found it works best with 12 clusters (for E. coli, in our experiences)
cl <- mfuzz(filteredVals.standardized,c=12,1.35)
O <- overlap(cl)

# This will produce a PCA plot looking at the overlap between the clusters, which is useful as a QC measure
pdf("PCA_plot.pdf",width=7,height=7)
	Ptmp <- overlap.plot(cl,over=O,thres=0.05)
dev.off()

jet.colors <- colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))

# Finally, do the clustering plot.  It differs every time you run the code from start to finish, so if the
# user wishes to keep the data, it is best to save the plots (preferrably as PDF), to have the plots that
# coincide with the 'cluster.csv' file produced below.
pdf("Clusters_plot.pdf",width=10,height=7)
	mfuzz.plot(filteredVals.standardized,cl=cl,mfrow=c(3,4),time.labels=round(timepoints[-1],2),colo=jet.colors(100),new.window=FALSE)
dev.off()

# Generate a file outlining the membership for each cluster, for each promoter.
clm <- cl$membership
memb <- c()
for(i in 1:nrow(clm)) {
	memb[i] <- as.numeric(which(clm[i,]==max(clm[i,])))
}
output <- cbind(names(cl$cluster),cl$cluster,cl$membership)
colnames(output) <- c("Promoter","Cluster",seq(1,12))

# Write the cluster membership file
write.table(output,"cluster.csv",row.names=FALSE,col.names=TRUE,sep="\t")
