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


coalsource <- SCC[SCC$EI.Sector == "Fuel Comb - Electric Generation - Coal" | SCC$EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal" | SCC$EI.Sector == "Fuel Comb - Comm/Institutional - Coal" , "SCC"]

subdata <- NEI[NEI$SCC %in% coalsource,]
subdata <- transform(subdata, SCC = factor(SCC))

subdata2 <- aggregate(Emissions ~ year, subdata, sum)

qplot(year, Emissions, data = subdata2)

#this is gigantic
ggsave("plot4.png")

#turn off device
dev.off