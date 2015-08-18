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
subdata <- aggregate(Emissions ~ year, NEI, sum)

png(file="plot1.png")

with(subdata, plot(year, Emissions, type = "b", main = "Total Yearly PM2.5 Emissions", xaxt = "n", yaxt = "n", xlab = "Year", ylab = "Emissions (tons)" ))
axis(1, c(1999,2002,2005,2008), labels = TRUE)
axis(2, c(4000000,5000000,6000000,7000000), labels = c("4000000","5000000","6000000","7000000"))

#turn off device
dev.off()