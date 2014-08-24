

##exploratory analysis proyect 1

if(!file.exists("proyecto2")){
  
  dir.create("proyecto2")  
  
}



url_dir<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
specdata<-setwd ("C:/Users/GMORENO/Documents/R/Exploratory Data analysis/proyecto2/")






##if the file does not exist then download and unzip it 
if(!file.exists("summarySCC_PM25.rds")){ 
  download.file(url_dir, destfile="FNI_data.zip") 
  unzip("FNI_data.zip") 
}



##Read the file 1
PM25 <- readRDS("summarySCC_PM25.rds")



## Questions

## You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.

## Get Baltimore Data

Baltimore.PM25<-PM25[PM25$fips=="24510",]
BaltimorePM25.year<- as.data.frame(sapply(split(Baltimore.PM25$Emissions,Baltimore.PM25$year),sum),col=1)
BaltimorePM25.ano<-as.data.frame(rownames(BaltimorePM25.year), col=1)
BaltimorePM25.year<- cbind(BaltimorePM25.ano,BaltimorePM25.year)
colnames(BaltimorePM25.year)<-c("Year","Sum")

## Create plot
png("plot2.png")
plot(BaltimorePM25.year$Year,log(BaltimorePM25.year$Sum), type="l", ylab="log(Emissions)")
dev.off()

## 3.Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? Which have seen increases in emissions from 1999-2008? Use the ggplot2 plotting system to make a plot answer this question.
library(ggplot2)
PM25.1<-aggregate(Emissions~year + type, data=Baltimore.PM25, sum)
PM25.1$type<-as.factor(PM25.1$type)
qplot(year,log(Emissions), data=PM25.1, facets= .~type,geom=c("point","smooth") , aes(fill= Emissions), color=year)
ggsave(file="plot3.png")