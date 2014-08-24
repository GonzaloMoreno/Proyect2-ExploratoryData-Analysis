
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


## 6.Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?
## to merge and choose SCC with combustion of coal and 

SCC <- readRDS("Source_Classification_Code.rds")
PM25 <- readRDS("summarySCC_PM25.rds")
PM25.veh<-merge(PM25,SCC, by.x= "SCC", by.y="SCC")
PM25.veh <-PM25.veh[grepl("[Mm]obile", PM25.veh$EI.Sector),]
PM25.veh<-PM25.veh[grepl("[Vv]eh", PM25.veh$Short.Name),]
Baltimore.veh<-PM25.veh[PM25.veh$fips=="24510",]
Angeles.veh<-PM25.veh[PM25.veh$fips=="06037",]
Total.MV<-rbind(Baltimore.veh, Angeles.veh)


Total.MV<-aggregate(Emissions~ year + fips,data=Total.MV, sum)


## to graph


library(ggplot2)


qplot(year,Emissions, data=Total.MV, color=fips,geom=c("point","smooth") )
ggsave(file="plot6.png")





}

