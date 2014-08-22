##
# Question #3
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

# As opposed to install.packages() function, require only installs
# the required package if it is not already installed
require('ggplot2')
library(ggplot2)

NEI_baltimore <- subset(NEI, NEI$fips == '24510')
NEI_baltimore_type <- split(NEI_baltimore, NEI_baltimore$type)
str(NEI_baltimore_type)
head(NEI_baltimore_type)
summary(NEI_baltimore_type)

names <- c()
df <- NULL
for (i in 1:length(NEI_baltimore_type)) {
  
  name <- unique(NEI_baltimore_type[[i]]$type)
  name <- paste('Emissions', name, sep = '.')
  name <- gsub('-', '_', name)
  names <- c(names, name)
  
  v1 <- with(NEI_baltimore_type[[i]], tapply(Emissions, year, sum, na.dm = TRUE))
  years <- names(v1)
  v1 <- unname(v1)
  
  types <- rep(name, times = 4)
  
  df1 <- data.frame(year = years, Emissions = v1, type = types)
  if (is.null(df))
    df = df1
  else
    df <- rbind(df, df1)
  
}

Palette1 <- c('red','green','blue','violet','black')

ggplot(df, aes(year, Emissions, colour = type)) +
  geom_point() + 
  geom_point(aes(size = Emissions)) + 
  scale_colour_manual(values = Palette1) +
  geom_line(aes(group = factor(df$type))) +
  theme(legend.position = 'bottom', plot.title = element_text(lineheight = 1.6, face = 'bold', size = 22)) +
  ylab('Emissions [ton]') +
  ylab('Year') +
  ggtitle('PM 2.5 Emissions by type, 1999 to 2008\nBaltimore City, MD')

# Save plot onto a file
dev.copy(png,'plot3.png')
dev.off()
