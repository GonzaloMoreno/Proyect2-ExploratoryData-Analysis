
url_dir<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
specdata<-setwd ("C:/Users/GMORENO/Documents/R/Exploratory Data analysis/proyecto2/")


##if the file does not exist then download and unzip it 
if(!file.exists("summarySCC_PM25.rds")){ 
  download.file(url_dir, destfile="FNI_data.zip") 
  unzip("FNI_data.zip") 
}



## 5.How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City? 

## to merge and choose SCC with combustion of coal and 
SCC <- readRDS("Source_Classification_Code.rds")
PM25 <- readRDS("summarySCC_PM25.rds")
PM25.veh<-merge(PM25,SCC, by.x= "SCC", by.y="SCC")
PM25.veh <-PM25.veh[grepl("[Mm]obile", PM25.veh$EI.Sector),]
PM25.veh<-PM25.veh[grepl("[Vv]eh", PM25.veh$Short.Name),]
Baltimore.veh<-PM25.veh[PM25.veh$fips=="24510",]

## to graph


library(ggplot2)

Total.balt.MV<-aggregate(Baltimore.veh$Emissions,list(Baltimore.veh$year), sum)
colnames(Total.balt.MV)<-c("year", "Emissions")
qplot(year,Emissions, data=Total.balt.MV, geom=c("point","smooth") )
ggsave(file="plot5.png")
