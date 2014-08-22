##
# Question #5
#
# https://github.com/davidedr/ExData_CP2
#
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

vehicles_related_EI.Sectors <- unique(grep('.*[vV]ehicles*', SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
vehicles_related <- SCC$EI.Sector %in% vehicles_related_EI.Sectors
vehicles_related_SCC <- SCC[vehicles_related, ]$SCC
NEI_vehicles_related <- NEI[NEI$SCC %in% vehicles_related_SCC, ]

NEI_vehicles_related_baltimore <- NEI[NEI_vehicles_related$fips == '24510', ]
dim(NEI_vehicles_related_baltimore)
total_emissions_per_year <- with(NEI_vehicles_related_baltimore,  tapply(Emissions, year, sum, na.dm = TRUE))
total_emissions_per_year
years_range = range(NEI$year)
str(years_range)
years_range_character = as.character(years_range)

main <- paste('Baltimore City, MD PM 2.5 Emissions\n', 'Vehicle-related, ', years_range_character[1], 'to', years_range_character[2], sep = ' ')
main

# Plot total emissions vs year
plot(names(total_emissions_per_year), total_emissions_per_year, col = 'red', lwd = 2, type = 'l', xlab = 'Year', ylab = 'Emissions [tons]', main = main, xaxt = 'n')
axis(side = 1, at = names(total_emissions_per_year), labels = names(total_emissions_per_year))
points(names(total_emissions_per_year), total_emissions_per_year, pch = 19, col = 'blue')

# Save plot onto a file
dev.copy(png,'plot5.png')
dev.off()
