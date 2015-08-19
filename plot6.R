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


motsource <- SCC[SCC$SCC.Level.One == "Mobile Sources" , "SCC"]

baldata <- NEI[NEI$fips == "24510",]
ladata <- NEI[NEI$fips == "06037",]

baldata2 <- baldata[baldata$SCC %in% motsource,]

baldata3 <- aggregate(Emissions ~ year, baldata2, sum)

ladata2 <- ladata[ladata$SCC %in% motsource,]

ladata3 <- aggregate(Emissions ~ year, ladata2, sum)


ggplot() + geom_point(data = baldata3, aes(x = year, y = Emissions)) +
  geom_point(data = ladata3, aes(x = year, y = Emissions), colour = 'red', size = 3)


#this is gigantic
ggsave("plot6.png")

#turn off device
dev.off