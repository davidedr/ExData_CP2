##
# Question #5
##
rm(list = ls())
setwd('C:/Nuova cartella/Exploratory Data Analysis/Course Project 2 - PM2.5')

# Read data
NEI = readRDS("summarySCC_PM25.rds")
str(NEI)
head(NEI)

SCC = readRDS("Source_Classification_Code.rds")
str(SCC)
head(SCC)

# Vehicles related data
vehicles_related_EI.Sectors <- unique(grep('.*[vV]ehicles*', SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
vehicles_related <- SCC$EI.Sector %in% vehicles_related_EI.Sectors
vehicles_related_SCC <- SCC[vehicles_related, ]$SCC
NEI_vehicles_related <- NEI[NEI$SCC %in% vehicles_related_SCC, ]

# Baltimore data
NEI_vehicles_related_baltimore <- NEI[NEI_vehicles_related$fips == '24510', ]
dim(NEI_vehicles_related_baltimore)

# Los Angeles data
NEI_vehicles_related_losangeles <- NEI[NEI_vehicles_related$fips == '06037', ]

total_emissions_baltimore <- with(NEI_vehicles_related_baltimore,  tapply(Emissions, year, sum, na.dm = TRUE))
total_emissions_losangeles <- with(NEI_vehicles_related_losangeles,  tapply(Emissions, year, sum, na.dm = TRUE))

years_range = range(NEI_vehicles_related_baltimore$year)
years_range_character = as.character(years_range)

emissions_range = range(total_emissions_baltimore, total_emissions_losangeles, na.rm = TRUE)

main <- paste('PM 2.5 Emissions\nBaltimore City, MD vs Los Angeles County\n', 'Vehicle-related, ', years_range_character[1], 'to', years_range_character[2], sep = ' ')

plot(names(total_emissions_baltimore), total_emissions_baltimore, col = 'red', lwd = 2, type = 'l', xlab = 'Year', ylab = 'Emissions [tons]', main = main, xaxt = 'n', ylim = emissions_range)
points(names(total_emissions_baltimore), total_emissions_baltimore, pch = 19, col = 'red')

lines(names(total_emissions_losangeles), total_emissions_losangeles, pch = 19, col = 'blue', lwd =2, type = 'l')
points(names(total_emissions_losangeles), total_emissions_losangeles, pch = 19, col = 'blue')
axis(side = 1, at = names(total_emissions_baltimore), labels = names(total_emissions_baltimore))

legend('topleft', c('Baltimore City, MD', 'Los Angeles County'), col = c('red', 'blue'), pch = 19)

# Save plot onto a file
dev.copy(png,'plot6.png')
dev.off()
