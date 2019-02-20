rm(list=ls())
dev.off()


package_required <- c("ggplot2", "sf", "ggspatial","maps","maptools","rgeos","purrr","tidyverse")
for (packages_name in package_required) {
  if(!is.element(packages_name, installed.packages()[])){
    install.packages(packages_name)
  }
  else {print(paste(packages_name,"library already installed"))}
}
sapply(package_required, require, character.only=TRUE)


p <- ggplot() +
  geom_sf(data = read_sf("data/ME-GIS/Coastline2.shp"), 
          colour="grey10", fill="grey90") +
  geom_sf(data = read_sf("data/ME-GIS/Rivers19.shp"), 
          colour="steelblue", size=0.3) +
  geom_sf(data = read_sf("data/ME-GIS/PrimaryRoads.shp"), 
          size = 0.7, colour="grey30") +
  geom_sf(data = read_sf("data/ME-GIS/Cities.shp")) +
  theme_bw()

p <- p +  geom_sf_text(aes(label = Name), data = read_sf("data/ME-GIS/Cities.shp")) +
  annotation_scale() +
  annotation_north_arrow()

ozbig <- read_sf("data/gadm36_AUS_shp/gadm36_AUS_1.shp")

oz_st <- maptools::thinnedSpatialPoly(
  as(ozbig, "Spatial"), tolerance = 0.1, 
  minarea = 0.001, topologyPreserve = TRUE)
oz <- st_as_sf(oz_st)

#ozplus <- as.tibble(oz) %>% mutate(
#  x = geometry %>% purrr::map_dbl(.f = function(m) m[[1]]$x),
#  y = geometry %>% purrr::map_dbl(.f = function(m) m[[1]]$y)
#) %>% head
  
ozplus %>% ggplot(aes(x = long, y = lat, group = group)) + geom_polygon()