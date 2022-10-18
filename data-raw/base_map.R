library(fofpack)
library(tidyverse)
library(rnaturalearth)

florida <- ne_states("united states of america", returnclass = "sf") %>%
  filter(name == "Florida") %>%
  select(geometry)

usethis::use_data(florida, overwrite = TRUE)
