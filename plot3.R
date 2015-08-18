library(ggplot2)

#download data if needed

if (!file.exists("./Source_Classification_Code.rds") | !file.exists("./summarySCC_PM25.rds")) {
  if (!file.exists("./exdata%2Fdata%2FNEI_data.zip")) {
    fURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
    download.file(fURL,destfile="exdata%2Fdata%2FNEI_data.zip")
  }
  unzip("./exdata%2Fdata%2FNEI_data.zip")
}

#read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#subset the data for the desired dates
subdata <- NEI[NEI$fips == "24510",]
subdata2 <- aggregate(Emissions ~ year + type, subdata, sum)
subdata2 <- transform(subdata2, type = factor(type))

qplot(year, Emissions, data = subdata2, facets = . ~ type)

#this is gigantic
ggsave("plot3.png")

#turn off device
dev.off