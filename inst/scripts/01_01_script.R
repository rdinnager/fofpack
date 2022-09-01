## Week 1 Introduction to R:
## the goals of this script are to :
## 1. import packages and load them
## 2. Explore a dataset: View (), glimpse(), kable(), use the extractor operator $

############# Load packages and try some basic R functions ################

## Load all required packages:
install.packages(c('dplyr', 'kableExtra', 'lubridate'))

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


## Answer the question:
## How can 2013 be the third driest year AND have the third wettest March, at the same time?


