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

## Summarize with dplyr
NEIBaltVehic <- tbl_df(NEI) %>%
  filter(fips == 24510, type == "ON-ROAD") %>%
  select(year, Emissions) %>%
  group_by(year) %>%
  summarize(Emissions = sum(Emissions)) %>%
  as.data.frame()

## Plot graph with ggplot2
g <- ggplot(NEIBaltVehic, aes(x = factor(year), y = Emissions, label = round(Emissions,0)))
g + geom_bar(stat = "identity") + geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Year",y = "Total Emissions (Tons)") +
  ggtitle(expression("Baltimore City Total PM"[2.5]*"Emissions by Year, Vehicle Sources")) +
  geom_label()


## Export to PNG
dev.copy(png, file = "plot5.png", width = 480, height = 480)
dev.off()
