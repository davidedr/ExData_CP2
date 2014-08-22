##
# Question #4
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

coal_related_EI.Sectors <- unique(grep('.*[cC]oal.*', SCC$EI.Sector, ignore.case = TRUE, value = TRUE))
coal_related <- SCC$EI.Sector %in% coal_related_EI.Sectors
length(coal_related)
head(coal_related)
sum(coal_related)

coal_related_SCC <- SCC[coal_related, ]$SCC
NEI_coal_related <- NEI[NEI$SCC %in% coal_related_SCC, ]
head(NEI_coal_related)
dim(NEI_coal_related)

total_emissions_per_year <- with(NEI_coal_related,  tapply(Emissions, year, sum, na.dm = TRUE))
total_emissions_per_year
years_range = range(NEI$year)
str(years_range)
years_range_character = as.character(years_range)

main <- paste('US PM 2.5 Emissions\n', 'Coal-related, ', years_range_character[1], 'to', years_range_character[2], sep = ' ')
main

# Plot total emissions vs year
plot(names(total_emissions_per_year), total_emissions_per_year, col = 'red', lwd = 2, type = 'l', xlab = 'Year', ylab = 'Emissions [tons]', main = main, xaxt = 'n')
axis(side = 1, at = names(total_emissions_per_year), labels = names(total_emissions_per_year))
points(names(total_emissions_per_year), total_emissions_per_year, pch = 19, col = 'blue')

# Save plot onto a file
dev.copy(png,'plot4.png')
dev.off()
