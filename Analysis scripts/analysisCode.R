# This code will take a 'timecourse_results.csv' file, process it, and return 
# a gfpData.Rdata file.  The code requires 'legend.txt' to be in the directory along
# with the 'timecourse_results.csv' file.  Look at the legend.txt file that I am sending
# with this code, and if you are using a different legend, please update it accordingly, as
# it will take promoter names and such from this file.

# To use this code, put timecourse_results.csv, and legend.txt, in the same directory
# and set this as the working directory with 'setwd(<directory name>)' in the R terminal.
# Copy and paste this entire code in that terminal window, and the output will be a file
# called 'gfpData.Rdata'.

# Using 'load('gfpData.Rdata')' in the R terminal will load
# this file, which is in a list format.  For example, gfpData[[1]]$raw.loess will call
# the loess-smoothed Raw data, and using 'summary(gfpData[[1]])' will give all the possible
# matrices associated with file.  Because it is set up as a list, multiple treatments can
# be combined into the same list, as seen on the GitHub repository:
# https://github.com/sfrench007/pfibox

# **Important** Also, the normalizeSolid function can be used to process 'endpoint' data,
# namely either the last timepoint from the raw (loess) data matrix, or alternatively the
# endpoint_results.csv file that is output from ImageJ.  Use it on the 'RawIntDen' column
# of the endpoint_results.csv file to normalize this raw data, removing the spatial (edge)
# effects on the plate if it is a 1536-or-6144 density plate

# If you have any questions at all, please email sfrench@mcmaster.ca, and I'll be happy
# to help if I can.


options(stringsAsFactors=FALSE)

#=========================[Begin functions]=============================
# Function to normalize solid media arrays, provided that they are in the form A1, A2, A3, ..., XX94, XX95, XX96.
# Basically, the arrays need to be 1536-colony density or higher, and have their placement 'left to right' on the plate,
# starting at A1,A2,..and ending at the bottom-right colony.  By default, the plate density is 6144, but changing
# plateFormat=1536 will work for 1536-density plates.  dataIn is the data to be normalized as a single vector.
# byQuadrant is important, as if 4-separate source plates are being pinned onto a single target (assay) plate, it is
# possible the inoculum may be different for each quadrant of the assay plate.  Setting this to TRUE breaks the assay
# plate into 4 quadrants and normalizes them separately, rather than normalizing the plate as a whole.  plateFormat only
# has an effect on 6144-density plates.
normalizeSolid <- function(dataIn,byQuadrant=FALSE,plateFormat=6144,...) {
	# Set rows and columns depending on plate format
	plates <- dataIn[1:plateFormat]
	colTemp <- plates

	if(plateFormat==1536) {
		colNumber <- 48
		rowNumber <- 32
	} else if(plateFormat==6144) {
		colNumber <- 96
		rowNumber <- 64
		# Define the individual quadrants, to break down 6144 into 4x 1536 if needed (if plateFormat=TRUE)
		q1 <- as.numeric(sapply(seq(1,64,by=2),function(x) seq(1,96,by=2)+(96*(x-1))))
		q2 <- as.numeric(sapply(seq(1,64,by=2),function(x) seq(2,96,by=2)+(96*(x-1))))
		q3 <- as.numeric(sapply(seq(2,64,by=2),function(x) seq(1,96,by=2)+(96*(x-1))))
		q4 <- as.numeric(sapply(seq(2,64,by=2),function(x) seq(2,96,by=2)+(96*(x-1))))
		columns <- seq(1,6144,by=96)
		rows <- seq(1,6144,by=64)
	}
	
	# If normalizing by quadrant, and it's 6144-density
	if(byQuadrant==TRUE & plateFormat==6144) {
		# Define as 4x 1536-density plates
		plateFormat <- 1536
		colNumber <- 48
		rowNumber <- 32
		plates2 <- plates
		plates3 <- plates

		# Loop through each quadrant
		for(hh in 1:4) {
			if(hh==1) {
				wval <- q1
			} else if(hh==2) {
				wval <- q2
			} else if(hh==3) {
				wval <- q3
			} else {
				wval <- q4
			}
			plates <- plates2[wval]
			colTemp <- plates

			# Row IQM
			for (g in 1:rowNumber) {
				tempMedian <- c()
				# Find IQM 
				for (i in seq(((g-1)*colNumber)+1,((g-1)*colNumber)+colNumber)) tempMedian[i] <- plates[i]
				tempMedian <- na.omit(tempMedian)
				# Find the IQM of the row
				rowMean <- mean(tempMedian[which(tempMedian>quantile(tempMedian)[2] & tempMedian<quantile(tempMedian)[4])])
				# Divide each value by the IQM
				for (i in seq(((g-1)*colNumber)+1,((g-1)*colNumber)+colNumber)) colTemp[i] <- plates[i]/rowMean
			}

			# Column IQM
			for (g in 1:colNumber) {
				tempMedian <- c()
				# Find IQM 
				for (i in seq(g,plateFormat,by=colNumber)) tempMedian[i] <- colTemp[i]
				tempMedian <- na.omit(tempMedian)
				# Find the IQM of the column
				colMean <- mean(tempMedian[which(tempMedian>quantile(tempMedian)[2] & tempMedian<quantile(tempMedian)[4])])
				# Divide each value by the IQM
				for (i in seq(g,plateFormat,by=colNumber)) colTemp[i] <- colTemp[i]/colMean
			}
			plates3[wval] <- colTemp
		}
		colTemp <- plates3
	} else {
		# Row IQM
		for (g in 1:rowNumber) {
			tempMedian <- c()
			# Find IQM 
			for (i in seq(((g-1)*colNumber)+1,((g-1)*colNumber)+colNumber)) tempMedian[i] <- plates[i]
			tempMedian <- na.omit(tempMedian)
			# Find the IQM of the row
			rowMean <- mean(tempMedian[which(tempMedian>quantile(tempMedian)[2] & tempMedian<quantile(tempMedian)[4])])
			# Divide each value by the IQM
			for (i in seq(((g-1)*colNumber)+1,((g-1)*colNumber)+colNumber)) colTemp[i] <- plates[i]/rowMean
		}

		# Column IQM
		for (g in 1:colNumber) {
			tempMedian <- c()
			# Find IQM 
			for (i in seq(g,plateFormat,by=colNumber)) tempMedian[i] <- colTemp[i]
			tempMedian <- na.omit(tempMedian)
			# Find the IQM of the column
			colMean <- mean(tempMedian[which(tempMedian>quantile(tempMedian)[2] & tempMedian<quantile(tempMedian)[4])])
			# Divide each value by the IQM
			for (i in seq(g,plateFormat,by=colNumber)) colTemp[i] <- colTemp[i]/colMean
		}
	}
	return(as.matrix(colTemp))
}

# Function to extract the timepoint values from the complicated row names
# that exist in the ImageJ/FIJI output tables that are imported into R.  The function
# returns the timepoint number, not the actual minutes/hours into the experiment
extractTimepoints <- function(datas=dataIn) {
	textIn <- datas[1,2]
	for(xx in 1:(nchar(textIn)-1)) {
		if(substr(textIn,xx,xx+1)==":") {
			break
		}
	}
	return(as.numeric(substr(datas[,2],xx+1,xx+4)))
}

# Given a list of colonies with radial distances, and a query colony,
# return the closest member of the list
findClosest <- function(inputVal,inputList=valsXY[,3]) {
	diffs <- sapply(inputList,function(xx) min(abs(inputVal-xx)))
	closest <- which(diffs==min(diffs))
	return(closest)
}

# Scale a set of curves based on their minimum and maximum values
normCurve <- function(vectorIn) {
	minVal <- min(vectorIn)
	maxVal <- max(vectorIn)
	vectorOut <- (vectorIn-minVal)/(maxVal-minVal)
	return(vectorOut)
}

#=========================[End functions]===============================


# Some initial setup
# Set the minute intervals for the timecourse (match the PFIbox intervals)
minuteIntervals <- 5
# The Loess smoothing lspan to use
smoothing <- 0.5
# Define the individual quadrants here, uncommented are for 6144-density
q1 <- as.numeric(sapply(seq(1,64,by=2),function(x) seq(1,96,by=2)+(96*(x-1))))
q2 <- as.numeric(sapply(seq(1,64,by=2),function(x) seq(2,96,by=2)+(96*(x-1))))
q3 <- as.numeric(sapply(seq(2,64,by=2),function(x) seq(1,96,by=2)+(96*(x-1))))
q4 <- as.numeric(sapply(seq(2,64,by=2),function(x) seq(2,96,by=2)+(96*(x-1))))

# These are for 1536-density (initially commented out)
# q1 <- as.numeric(sapply(seq(1,32,by=2),function(x) seq(1,48,by=2)+(48*(x-1))))
# q2 <- as.numeric(sapply(seq(1,32,by=2),function(x) seq(2,48,by=2)+(48*(x-1))))
# q3 <- as.numeric(sapply(seq(2,32,by=2),function(x) seq(1,48,by=2)+(48*(x-1))))
# q4 <- as.numeric(sapply(seq(2,32,by=2),function(x) seq(2,48,by=2)+(48*(x-1))))

# Assign radial distances from the center of the plate, to find the closest constitutive
# promoter to the colony of interest.  Spatial effects are radial from the center, so this
# finds the most appropriate constitutive promoter.  This is for 6144-density plates, the
# code for 1536-density plates is commented out directly below
columns <- seq(1,6144,by=96)
radialX <- abs(seq(1,96)-(96/2))
radialX <- radialX[-which(radialX==0)]
radialX <- c(max(radialX),radialX)
rows <- seq(1,6144,by=64)
radialY <- abs(seq(1,64)-(64/2))
radialY <- radialY[-which(radialY==0)]
radialY <- c(max(radialY),radialY)

# For 1536-density plates
# columns <- seq(1,1536,by=48)
# radialX <- abs(seq(1,48)-(48/2))
# radialX <- radialX[-which(radialX==0)]
# radialX <- c(max(radialX),radialX)
# rows <- seq(1,1536,by=32)
# radialY <- abs(seq(1,32)-(32/2))
# radialY <- radialY[-which(radialY==0)]
# radialY <- c(max(radialY),radialY)

# Assign colony X,Y,Distance,Quadrant values in a table for fast lookup
for(i in 1:length(radialY)) {
	radialTemp <- cbind(radialY[i],radialX)
	radialDistance <- apply(radialTemp,1,function(x) sqrt((x[1]^2)+(x[2]^2)))
	radialTemp <- cbind(radialTemp,radialDistance)
	if(i==1) radialXY <- radialTemp
	else radialXY <- rbind(radialXY,radialTemp)
}
radialXY <- cbind(radialXY,0)
radialXY[q1,4] <- 1
radialXY[q2,4] <- 2
radialXY[q3,4] <- 3
radialXY[q4,4] <- 4
colnames(radialXY) <- c("RadialY","RadialX","RadialDistance","Quadrant")
# Returns a table in the form of (6144-density example):
# > head(radialXY)
#      RadialY RadialX RadialDistance Quadrant
# [1,]      32      48       57.68882        1
# [2,]      32      47       56.85948        2
# [3,]      32      46       56.03570        1
# [4,]      32      45       55.21775        2

# Now the actual data processing and analysis begins
# Load the required files, first the legend:
legendGFP <- read.csv("legend.txt",sep="\t",header=TRUE)
empty <- which(legendGFP[,1]=="Empty")
pua66 <- which(legendGFP[,1]=="U66" | legendGFP[,1]=="U139")

# Next the timecourse_results.csv file from FIJI/ImageJ
dataIn <- read.csv("timecourse_results.csv",sep=",",header=TRUE)
# extract the timepoints from the ImageJ table using the extractTimepoints function (above)
times <- extractTimepoints()

# Reorder based on extracted timepoints to make the raw matrix
# Make a quick progress bar for troubleshooting purposes
pb <- txtProgressBar(min=min(times),max=max(times),style=3)
# For each unique timepoint
for(i in unique(times)) {
	# Get the RawIntDen (raw integrated density) at this timepoint, from the ImageJ file
	newLine <- dataIn[which(times==i),4]
	# If it's the first timepoint, start a new file
	if(i==min(unique(times))) {
		rawData <- as.matrix(newLine)
	# Otherwise append to the first timepoint
	} else {
		rawData <- cbind(rawData,as.matrix(newLine))
	}
	# Update the progress bar
	setTxtProgressBar(pb,i)
}
# This can be QCd very quickly with:
# matplot(y=t(rawData),x=timepoints,type="l",col=rgb(0,0,0,0.1),lwd=2,lty=1,ylab="Fluorescence Intensity",xlab="Time (h)")

# Identify the timepoints (in hours) from the minute intervals (set above) and raw data
timepoints <- (seq(0,(ncol(rawData)-1)*minuteIntervals,by=minuteIntervals))/60

# Loess smoothing algorithm for raw data, based on the 'smoothing' span set above.  An
# intensive smoothing is likely not required, as the data coming out of ImageJ is typically
# quite good, but even a low span smoothing helps reduce noise in downstream derivatives
loessData <- t(apply(rawData,1,function(x) predict(loess(x~timepoints,span=smoothing))))
# This can be QCd very quickly with:
# matplot(y=t(loessData),x=timepoints,type="l",col=rgb(0,0,0,0.1),lwd=2,lty=1,ylab="Fluorescence Intensity",xlab="Time (h)")

# Based on set constitutive promoters.  This is a vector of INDEX VALUES where the
# constitutive promoters are located in the legend.txt file that is used.  If users are
# medium other than LB, or are changing conditions, their constitutive promoters should be
# indicated as index values as 'constit' below
constit <- c(120,128,1826,4608,5184,5666,5952,6058,6060,6062,6066,6076,6078,6080,6082,6084,6090,6092,6108,6110,6114,6122,6136,6144,384,3840,5858,6050,6056,6072,6106,6112,6116,6118,6142,5760,5938,6086,118,576,5474,6054,5890,5892,5898,5940,5946,6052,6138,6140,3648,512,2234,3826)
constitXY <- radialXY[constit,]

# Go through GFP data to get endpoint counts, normalize constitutives to 1, then 
# multiply closest constitutive by endpoint
# Get endpoint column from data
finalVals <- loessData[,ncol(loessData)]
valsXY <- cbind(radialXY,finalVals)
pua66GFP <- loessData

# Loop through the data, this is for a 6144-density plate, users must adjust 
# acordingly for 1536-density plates
pb <- txtProgressBar(min=1,max=6144,style=3)
for(i in 1:6144) {
	constitValsXY <- valsXY[constit,]
	pua66ValsXY <- valsXY[pua66,]

	# Use the function findClosest (above) to find the closest colony to the query one
	closestConstit <- findClosest(valsXY[i,3],constitValsXY[,3])
	closestPua66 <- findClosest(valsXY[i,3],pua66ValsXY[,3])
	
	# Go through each match and get the 6144 row numbers
	matchOut <- c()
	matchOut2 <- c()
	for(k in 1:length(closestConstit)) {
		theMatch <- which(valsXY[,4]==constitValsXY[closestConstit[k],4] & valsXY[,5]==constitValsXY[closestConstit[k],5])
		matchOut[k] <- theMatch[1]
	}
	for(k in 1:length(closestPua66)) {
		theMatch2 <- which(valsXY[,4]==pua66ValsXY[closestPua66[k],4] & valsXY[,5]==pua66ValsXY[closestPua66[k],5])
		matchOut2[k] <- theMatch2[1]
	}

	# Return the closest constitutive GFP, and the closest promoterless plasmid
	if(i==1) {
		constitGFPout <- loessData[matchOut[1],]
		pua66GFPout <- pua66GFP[matchOut2[1],]
	} else {
		constitGFPout <- rbind(constitGFPout,loessData[matchOut[1],])
		pua66GFPout <- rbind(pua66GFPout,pua66GFP[matchOut2[1],])
	}
	setTxtProgressBar(pb,i)
}

# Background subtract the nearest promoterless plasmid GFP
gfpBackSub <- loessData-pua66GFPout
# constitGFPout <- t(apply(constitGFPout,1,function(x) x/max(x)))

# Generate the pseudo-OD normalized data using the consitutive reporters. 
normLoessGFP <- (gfpBackSub/constitGFPout)
normLoessGFP[which(normLoessGFP<0,arr.ind=TRUE)] <- 0

# Derivative now, effectively the promoter activity
dGFPdtGFP <- t(apply(normLoessGFP,1,diff))

# One final smooting of the promoter activity data - the GFP/biomass data is often a little
# 'jittery', so taking the first-order derivative reflects even slight changes in that curve.
# Doing another Loess smooth here follows the trends of the curves.
loessdGFPdtGFP <- t(apply(dGFPdtGFP[,1:216],1,function(x) predict(loess(x~timepoints[-1][1:216],span=smoothing))))
# Then scale between 0-1 for clustering purposes downstream
loessdGFPdtGFP_scale <- t(apply(loessdGFPdtGFP,1,normCurve))

# Create the output file.  The treatment name 'timecourse_results' are added here as a dummy
# name, if the user is looping through multiple files, this value can be modified to reflect
# the actual treatment name, effectively compiling multiple treatments into a single Rdata
# file for easier loading and downstream analyses
gfpData <- list()
gfpData[["timecourse_results"]]$legend <- legendGFP
gfpData[["timecourse_results"]]$raw <- rawData
gfpData[["timecourse_results"]]$raw.loess <- loessData
gfpData[["timecourse_results"]]$constit.normalized <- normLoessGFP[,20:ncol(normLoessGFP)]
gfpData[["timecourse_results"]]$promoter.activity <- loessdGFPdtGFP_scale

# Export the .Rdata file containing the list
save(gfpData,file="gfpData.Rdata")
