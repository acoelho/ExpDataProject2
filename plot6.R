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

#create list of SCC values that have one of the 4 EI.Sector values that represent motor vehicles (taken to mean 'road vehicles')
motsource <- SCC[SCC$EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles" | SCC$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles" | 
                   SCC$EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" | SCC$EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles" , "SCC"]

#Selecting only the Baltimore City data
baldata <- NEI[NEI$fips == "24510",]

#Selecting only the Los Angeles data
ladata <- NEI[NEI$fips == "06037",]

#selecting only motor vehicle rows of Baltimore subset
baldata2 <- baldata[baldata$SCC %in% motsource,]

#Summing Baltimore motor vehicle emissions by year
baldata3 <- aggregate(Emissions ~ year, baldata2, sum)

#selecting only motor vehicle rows of Los Angeles subset
ladata2 <- ladata[ladata$SCC %in% motsource,]

#Summing Los Angeles motor vehicle emissions by year
ladata3 <- aggregate(Emissions ~ year, ladata2, sum)

#plotting
my_plot <-  ggplot() + geom_line(data = baldata3, aes(x = year, y = Emissions, color = "Baltimore") ) +
  geom_line(data = ladata3, aes(x = year, y = Emissions, colour = "Los Angeles")) +
  labs(title="Motor Vehicle Emissions", x="Year", y="Emissions (tons)") +
  scale_colour_discrete(name  ="City")

#turning on device
png("plot6.png")

#saving plot
print(my_plot)

#turn off device
dev.off()