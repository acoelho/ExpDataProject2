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

#turning on device
png(file="plot2.png")

#subset the data
#Selecting only the Baltimore City data
subdata <- NEI[NEI$fips == "24510",]

#Summing emissions by year
subdata2 <-  aggregate(Emissions ~ year, subdata, sum)

#plotting
with(subdata2, plot(year, Emissions, type = "b", main = "Baltimore Yearly PM2.5 Emissions", xaxt = "n", yaxt = "n", xlab = "Year", ylab = "Emissions (tons)" ))
axis(1, c(1999,2002,2005,2008), labels = TRUE)
axis(2, c(1000,2000,3000,4000), labels = c("1000","2000","3000","4000"))

#turn off device
dev.off()