##
# Question #2
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

# Subset data to get only Baltimore readings
NEI_baltimore <- subset(NEI, NEI$fips == '24510')

total_emissions_per_year_baltimore <- with(NEI_baltimore,  tapply(Emissions, year, sum, na.dm = TRUE))

str(total_emissions_per_year_baltimore)
total_emissions_per_year_baltimore
names(total_emissions_per_year_baltimore)

years_range_baltimore = range(NEI_baltimore$year)
str(years_range_baltimore)
years_range__baltimore_character = as.character(years_range_baltimore)

main <- paste('PM 2.5 Emissions\n', 'Baltimore City, MD,', years_range__baltimore_character[1], 'to', years_range__baltimore_character[2], sep = ' ')

plot(names(total_emissions_per_year_baltimore), total_emissions_per_year_baltimore, col = 'red', lwd = 2, type = 'l', xlab = 'Year', ylab = 'Emissions [tons]', main = main, xaxt = 'n')
axis(side = 1, at = names(total_emissions_per_year_baltimore), labels = names(total_emissions_per_year_baltimore))
points(names(total_emissions_per_year_baltimore), total_emissions_per_year_baltimore, pch = 19, col = 'blue')

# Save plot onto a file
dev.copy(png,'plot2.png')
dev.off()
