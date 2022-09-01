# Working with data in R:
# We have two seasons in south Florida, the wet and the dry season? It feels like it hasnt rained in a while. Is it wetter than normal
# Load all required packages: using library() dplyr and knitr
library(dplyr)
library(lubridate)
library(ggplot2)

# Load the data set : using load() "EDEN.RDATA"
load("EDEN.RDATA")

# use View() and summary() to look at the data frame:
View(water)
summary(water)

# Rename columns and change column names with names() to c("Date", "waterl", "type", "qaqc"):

names(water) <- c("Date", "waterl", "type", "qaqc")

# Should some of the characters be factors? If so, make them a factor
unique(water$type)
unique(water$qaqc)

class(water$type)
water$type <- as.factor(water$type)

class(water$qaqc)
water$qaqc <- as.factor(water$qaqc)

summary(water$type)

# Format the date using lubridate
class(water$Date)
water$Date <- as_date(water$Date)

# Make sure water level is numeric:
class(water$waterl)
class(water$Date)

# Get the month from the date:
water$month <- month(water$Date)

# Define wet and dry season:
water$season <- "wet"
water$season[ water$month < 5 | water$month > 10 ] <- "dry"
unique(water$season)

water$season <- as.factor(water$season)
summary(water$season)

# Answer the question? Follow along or be creative:
# What is different about the years 2016 and 2020, in terms of their water levels?
# Calculate and plot the yearly means:
year_means <- water %>%
  group_by(year(Date)) %>%
  summarise(mean(waterl))

plot(year_means$`year(Date)`, year_means$`mean(waterl)`, type = "l")
the_years <- year_means$`year(Date)` %in% c(2016, 2020)
points(year_means$`year(Date)`[the_years], year_means$`mean(waterl)`[the_years],
       pch = 19, cex = 3)

# Do 2016 and 2020 seems different in the means?
# plot all the data:
plot(x = water$Date, y = water$waterl, type = "n")
abline(v = water$Date[water$season == "wet"], col = "lightblue")
lines(x = water$Date, y = water$waterl)
abline(h = mean(water$waterl, na.rm=T))
abline(h = mean(water$waterl[water$season == "wet"], na.rm = T), col = "blue")
abline(h = mean(water$waterl[water$season == "dry"], na.rm = T), col = "red")


## export plot in RStudio

# Using GGPLOT2!
library(ggplot2)

ggplot(data = water, mapping = aes(x = Date, y = waterl)) + 
  # geom_vline(aes(xintercept = Date, colour = season),
  #            alpha = 0.5) +
  geom_line()

p <- ggplot(data = water, mapping = aes(x = Date, y = waterl)) + 
  geom_line()

class(p)

p

p <- p + 
  geom_hline(yintercept = mean(water$waterl[water$season == "wet"], na.rm = T),
             colour = "red")

p

## export plot
ggsave("a_better_looking_pdf.pdf")
ggsave("a_better_looking_png.png")  

####################### Assignment part 1: start ############################
# Make a plot of the water level, with the overall mean and the two seasonal means as 3 horizontal lines:
# Hint: You need to add two more lines to the above plot

#_____________________________________________________________________________________
#_____________________________________________________________________________________
#_____________________________________________________________________________________

# Bonus challenge:
# Make the same plot but include a legend or labels to describe what the 3 lines are:
# Hint: To get an automatic legend, data need to be input as a data.frame, with
# columns mapped to aesthetics. Some code from last week's script might be useful for this. 
# Lines can also be directly labelled.

###################### Assignment part 1: end ###############################


# Once you learn to wrangle the data we can answer the question in a better way:

# get the day of the year and the year from the date:
water$doy <- yday(water$Date)
water$year <- year(water$Date)

# get the mean water level for each DOY, and year:
water <- water %>% 
  group_by(doy) %>% 
  mutate(avg_doy = mean(waterl, na.rm = T)) %>%
  group_by(year) %>%
  mutate(avg_year = mean(waterl, na.rm = TRUE))

# Create a plot in base R
plot(x = water$Date, y = water$waterl, type = "n") 
abline(v = water$Date[water$season == "wet"], col = "lightblue")
segments(x0 = water$Date, y0 = pmin(water$waterl, water$avg_doy),
         x1 = water$Date, y1 = pmax(water$waterl, water$avg_doy),
         col = "lightpink")
lines(x = water$Date, y = water$waterl)
lines(x = water$Date, y = water$avg_doy, typ = "l", col = "hotpink")
lines(x = water$Date, y = water$avg_year, typ = "l", lty = 2, col = "grey")
## highlight 2016 and 2020
lines(x = water$Date[water$year == 2016], y = water$avg_year[water$year == 2016], typ = "l", lwd = 4)
lines(x = water$Date[water$year == 2020], y = water$avg_year[water$year == 2020], typ = "l", lwd = 4)

####################### Assignment part 2: start ############################
# Create a similar plot in ggplot
# Start by just plotting the water level and the average day of year water level over time


# Now fill in as much of the other detail as you can. If you can't figure it all out don't worry, just give it
# a try. Notes about why certain code doesn't work in the comments counts as effort. 

# export plot as png file

####################### Assignment part 2: end ############################

####################### Assignment part 3: start ############################

# Here is some data wrangling practice
# Remove data with potential issues (Hint: find out what QAQC and TYPE are):
# water$waterl[water$type != "O"] <- NA

## replot the base R plot from line 125 above:

####################### Assignment part 3: end ############################

