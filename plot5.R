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

#create list of SCC values that have one of the 4 EI.Sector values that represent motor vehicles (taken to mean 'road vehicles')
motsource <- SCC[SCC$EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles" | SCC$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles" | 
                   SCC$EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" | SCC$EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles" , "SCC"]

#Selecting only the Baltimore City data
subdata <- NEI[NEI$fips == "24510",]

#selecting only motor vehicle rows of NEI
subdata2 <- subdata[subdata$SCC %in% motsource,]

#Summing emissions by year
subdata3 <- aggregate(Emissions ~ year, subdata2, sum)

#plotting
my_plot <-  qplot(year, Emissions, data = subdata3, geom=c("point", "line")) +
  labs(title="Motor Vehicle Emissions (Baltimore)", x="Year", y="Emissions (tons)") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#turning on device
png("plot5.png")

#saving plot
print(my_plot)

#turn off device
dev.off()