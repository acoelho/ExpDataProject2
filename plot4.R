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

#create list of SCC values that have one of the 3 EI.Sector values that represent coal combustion
coalsource <- SCC[SCC$EI.Sector == "Fuel Comb - Electric Generation - Coal" | SCC$EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal" | SCC$EI.Sector == "Fuel Comb - Comm/Institutional - Coal" , "SCC"]

#selecting only coal combustion rows of NEI
subdata <- NEI[NEI$SCC %in% coalsource,]

#Summing emissions by year
subdata2 <- aggregate(Emissions ~ year, subdata, sum)

#plotting
my_plot <-  qplot(year, Emissions, data = subdata2, geom=c("point", "line")) +
  labs(title="Coal Combustion Emisisons (US)", x="Year", y="Emissions (tons)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


#turning on device
png("plot4.png")

#saving plot
print(my_plot)

#turn off device
dev.off()