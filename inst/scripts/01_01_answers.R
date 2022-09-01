## Week 1 Introduction to R:
## the goals of this script are to :
## 1. import packages and load them
## 2. Explore a dataset: View (), glimpse(), kable(), use the extractor operator $

############# Load packages and try some basic R functions ################

## Load all required packages:
#install.packages(c('dplyr', 'kableExtra', 'lubridate'))

library(dplyr) 
library(kableExtra)
library(lubridate)

## Check your working directory:
getwd()

## Getting help with function arguments: You can put a ? in from of a function to get help on how to use it if the package is loaded but if it isnt, you use ??
args(round)
round(8.19,0)
?round()
?mode()

library(ggplot2)
??ggplot()

a <- 1
class(a)
mode(a)

b <- "1"
class(b)
mode(b)

a+b ## Can you do math on a character?

class(b) <- "numeric"

a+b 

rm(a,b)

################### Working with data in R: ##################
## We have two seasons in south Florida, the wet and the dry season? Is it wetter or drier than normal?
# rm(list=ls()) Instead, restart R with Rstudio
load("EDEN.RDATA")

View(water)

glimpse(water)
summary(water)


## Rename Columns and change column names with the names function
names(water)
names(water) <- c("Date", "waterl", "type", "qaqc")

## A pretty table
kbl(water)

## prettier and with scroll bars
kbl(water) %>% 
  kable_styling() %>% 
  scroll_box(height = "400px")

## should some of the characters be factors? If so, make them a factor
unique(water$type)
water$type <- as.factor(water$type)
water$qaqc <- as.factor(water$qaqc)
summary(water$type )
summary(water$qaqc )

## Format the date?
summary(water$Date)
water$Date
## base R way of using dates
#water$Date <- as.Date(water$Date, format="%Y-%m-%d" ) 
## lubridate is easier, it can automatically detect most date formats
water$Date <- as_date(water$Date)
class(water$Date)
summary(water$Date)

## Separate extract the month?
# water$month <- format(water$Date, format='%m')
water$month <- month(water$Date)
kbl(water) %>% 
  kable_styling() %>% 
  scroll_box(height = "400px")

## Define wet and dry season:

## wet season is between May and October
water$season <- ifelse(water$month > 5 & water$month <= 10,
                       "wet",
                       "dry")
## make it a factor
water$season <- as.factor(water$season)
water$month <- as.factor(water$month)

## summarise it

plot(water$Date, water$waterl, type = "l", col = "grey")
points(water$Date, water$waterl, col = c("red", "blue")[water$season], pch = 19, cex = 0.5)
legend("bottomright", c("dry", "wet"), col = c("red", "blue"), pch = 19)
abline(h=mean(water$waterl ))
abline(h=mean(water$waterl[ water$season =="wet"] ), col='blue')

## Answer the question:
## How can 2013 be the third driest year AND have the third wettest March, at the same time?

water$year <- as.factor(year(water$Date))

## find the driest years

year_summ <- water %>%
  group_by(year) %>%
  summarise(mean_waterl = mean(waterl)) %>%
  arrange(mean_waterl)

year_summ
year_summ$year[order(year_summ$mean_waterl) == 3]

## find wettest Marchs

year_month_summ <- water %>%
  group_by(year, month) %>%
  summarize(mean_waterl = mean(waterl), .groups = "drop")

marches <- year_month_summ %>%
  filter(month == "3") %>%
  arrange(desc(mean_waterl))

marches

marches$year[order(marches$mean_waterl, decreasing = TRUE) == 3]

## make a plot that tries to show that

## add yearly means back to daily data
water <- water %>%
  left_join(year_summ)

## make a blank plot to put stuff on
plot(water$Date, water$waterl, type = "n")
## highlight month of March in green
abline(v = water$Date[water$month == 3], col = "green")
## plot water-level as grey line
lines(water$Date, water$waterl, col = "grey")
## now add points for dry and wet season
points(water$Date, water$waterl, col = c("red", "blue")[water$season], pch = 19, cex = 0.5)
## add the average for the year in hot pink!
lines(water$Date, water$mean_waterl, col="hotpink", lty=2, lwd = 2)
## where is 2014?
abline(v = water$Date[water$year == "2014" & water$month == "1"][1])
abline(v = water$Date[water$year == "2015" & water$month == "1"][1])
## help with finding the wettest marches
#abline(h = marches$mean_waterl[marches$year == "2014"])
legend("bottomright", c("dry", "wet"), col = c("red", "blue"), pch = 19)
