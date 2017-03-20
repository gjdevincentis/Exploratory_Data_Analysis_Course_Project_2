library(dplyr)
library(ggplot2)
## set url1 for data set and temporary file name
url1 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename <- "Data.zip"

## Download and unzip file if not already in working directory
if(!file.exists(filename)){
  download.file(url1,filename,method = "curl")
  unzip(filename)
}

## Read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## transform data using dplyr
totalemissions <- tbl_df(NEI) %>%
  filter(fips == 24510) %>%
  select(year,type,Emissions) %>%
  group_by(type,year) %>%
  summarize(sum(Emissions)/1000) %>%
  as.data.frame()

## rename fields
names(totalemissions) <- c("type","year","emissionsTT")

## plot graph using ggplot2
g <- ggplot(totalemissions, aes(x = factor(year), y = emissionsTT))
g + facet_grid(.~type) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  labs(x = "Year",y = "Total Emissions (Thousands of Tons)") +
  ggtitle(expression("Total PM"[2.5]*" Emissions by Year, by Source Type"))


## Export to PNG
dev.copy(png, file = "plot3.png", width = 480, height = 480)
dev.off()
