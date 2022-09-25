library(sf)
library(fofpack)
library(tidyverse)
library(terra)

data(IRC)

parks <- st_read("parks_shape")


IRC_sf <- IRC %>%
  group_by(area_name) %>%
  summarise(long = long[1], lat = lat[1]) %>%
  filter(!is.na(long), !is.na(lat)) %>%
  st_as_sf(coords = c("long", "lat"),
           crs = 4326,
           remove = FALSE) %>%
  st_transform(st_crs(parks))

irc_spat <- IRC_sf %>%
  st_join(parks,
          join = st_nearest_feature) %>%
  filter(!is.na(MANAME)) %>%
  as_tibble() %>%
  select(-geometry) %>%
  left_join(parks %>%
              select(MANAME)) %>%
  st_as_sf()

write_rds(irc_spat, "data/irc_spat.rds")
rm(irc_spat)
rm(parks)
rm(IRC_sf)
rm(IRC)

######### land cover ##############

#CLC <- rast("data/CLC_raster/CLC_v3_5_Raster.gdb")
CLC <- st_read("data/CLC_v3_5.gdb")

