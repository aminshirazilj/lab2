library(ggplot2)
library(sf)


p <- ggplot() +
  geom_sf(data = read_sf("data/ME-GIS/Coastline2.shp"), 
          colour="grey10", fill="grey90") +
  geom_sf(data = read_sf("data/ME-GIS/Rivers19.shp"), 
          colour="steelblue", size=0.3) +
  geom_sf(data = read_sf("data/ME-GIS/PrimaryRoads.shp"), 
          size = 0.7, colour="grey30") +
  geom_sf(data = read_sf("data/ME-GIS/Cities.shp")) +
  geom_sf_text(aes(label = Name), data = read_sf("data/ME-GIS/Cities.shp")) +
  theme_bw()
p
library(ggspatial)
p+annotation_scale()+ annotation_north_arrow()
