

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





## Questions

## You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.



## 4.Across the United States, how have emissions from coal 
## combustion-related sources changed from 1999-2008?
##Read the file 2

## to merge and choose SCC with combustion of coal and 
SCC <- readRDS("Source_Classification_Code.rds")
PM25 <- readRDS("summarySCC_PM25.rds")
PM25.coal_comb<-merge(PM25,SCC, by.x= "SCC", by.y="SCC")
PM25.coal_comb <-PM25.coal_comb[grepl("[Cc][Oo][Mm][Bb]", PM25.coal_comb$EI.Sector),]
PM25.coal_comb<-PM25.coal_comb[grepl("[Cc][Oo][Aa][Ll]", PM25.coal_comb$EI.Sector),]


## to graph
library(ggplot2)

Total.coal_comb<-aggregate(PM25.coal_comb$Emissions,list(PM25.coal_comb$year), sum)
colnames(Total.coal_comb)<-c("year", "Emissions")
qplot(year,Emissions, data=Total.coal_comb, geom=c("point","smooth"))
ggsave(file="plot4.png")
