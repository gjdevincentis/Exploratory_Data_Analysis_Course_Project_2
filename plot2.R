library(dplyr)

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
  select(year,Emissions) %>%
  group_by(year) %>%
  summarize(sum(Emissions)/1000) %>%
  as.data.frame()

## rename fields
names(totalemissions) <- c("year","emissionsMT")


## plot graph
with(totalemissions,
     barplot(emissionsMT, year
             ,main = bquote(atop("Total PM"[2.5]*" Emisisons by Year",
                             "in Baltimore City, MD"))
             ,xlab = "Year"
             ,ylab = "Emissions (Thousands of Tons)"
             ,names.arg = year
     )
)

## Export to PNG
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
