
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
  
  ## 1.Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.
  
  TotalPM25.year<- as.data.frame(sapply(split(PM25$Emissions,PM25$year),sum),col=1)
  PM25.ano<-as.data.frame(rownames(TotalPM25.year), col=1)
  TotalPM25.year<- cbind(PM25.ano,TotalPM25.year)
  colnames(TotalPM25.year)<-c("Year","Sum")

png("plot1.png")
plot(TotalPM25.year$Year, log(TotalPM25.year$Sum), type="h", ylab="log(Emissions)")

dev.off()

## 2.Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.

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
   ##  PM25.1<-aggregate(Emissions~year + type, data=Baltimore.PM25, sum)
  
  ## to graph
  
  
  library(ggplot2)
  
 
  qplot(year,Emissions, data=Total.MV, color=fips,geom=c("point","smooth") )
  ggsave(file="plot6.png")
  
  
  
  
  
  }



