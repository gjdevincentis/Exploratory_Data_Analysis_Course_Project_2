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

## merge data frames, and summarize data
join <- merge(NEI,SCC,by = "SCC", all.x = TRUE)
join2 <- subset(join, select = c(6,9,4))
coalmatch <- grep("coal",join2$EI.Sector,ignore.case = TRUE)
join3 <- join2[coalmatch,]
join4 <- tbl_df(join3) %>%
  select(year,Emissions) %>%
  group_by(year) %>%
  summarize(EmissionsTT = sum(Emissions)/1000)
  

## plot graph
g <- ggplot(join4, aes(x = factor(year), y = EmissionsTT, label = round(EmissionsTT,0)))
g + geom_bar(stat = "identity") + geom_smooth(method = "lm", se = FALSE) +
  labs(x = "Year",y = "Total Emissions (KiloTons)") +
  ggtitle(expression("Total PM"[2.5]*" Emissions by Year, Coal Sources")) +
  geom_label()


## Export to PNG
dev.copy(png, file = "plot4.png", width = 480, height = 480)
dev.off()
