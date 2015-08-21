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

#subset the data

#Selecting only the Baltimore City data
subdata <- NEI[NEI$fips == "24510",]

#Summing emissions by type and year
subdata2 <- aggregate(Emissions ~ year + type, subdata, sum)
#converting type to a factor 
subdata2 <- transform(subdata2, type = factor(type))

#plotting
my_plot <- qplot(year, Emissions, data = subdata2, facets = . ~ type, aes(x=year), geom=c("point", "line"), color = type) +
  labs(title="Baltimore Total Emissions by type and year", x="Year", y="Emissions (tons)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#turning on device
png("plot3.png")

#saving plot
print(my_plot)

#turn off device
dev.off()