
## He borrado todos los comentarios y he puesto este para la egunda rama que cree desde github
## Ahora son las 6:43 y pondré un segundo comentario antes del merge


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

## 1.Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

TotalPM25.year<- as.data.frame(sapply(split(PM25$Emissions,PM25$year),sum),col=1)
PM25.ano<-as.data.frame(rownames(TotalPM25.year), col=1)
TotalPM25.year<- cbind(PM25.ano,TotalPM25.year)
colnames(TotalPM25.year)<-c("Year","Sum")

png("plot1.png")
plot(TotalPM25.year$Year, log(TotalPM25.year$Sum), type="h", ylab="log(Emissions)")

dev.off()
