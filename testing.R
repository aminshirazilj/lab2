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

ozplus <- oz %>% select(NAME_1, geometry) %>% 
  group_by() %>% 
  mutate(coord = geometry %>% map(.f = function(m) flatten(.x=m)),
         region = row_number()) %>% 
  unnest
st_geometry(ozplus) <- NULL
ozplus <- ozplus %>% mutate(coord = coord %>% map(.f = function(m) as_tibble(m)),
                            group = row_number()) %>% 
  unnest

ozplus %>%  setNames(c("name", "region","group", "long", "lat")) %>% 
  ggplot(aes(x = long, y = lat, group = group)) + geom_polygon(color = "black")



# packing into function
shpBigToSmall <- function(dsn) {
  package_required <- c("sf","purrr","tidyverse")
  for (packages_name in package_required) {
    if(!is.element(packages_name, installed.packages()[])){
      install.packages(packages_name)
    }
    else {print(paste(packages_name,"library already installed"))}
  }
  sapply(package_required, require, character.only=TRUE)
  
  shpbig <- read_sf(dsn)
  shp_st <- maptools::thinnedSpatialPoly(
    as(shpbig, "Spatial"), tolerance = 0.1, 
    minarea = 0.001, topologyPreserve = TRUE)
  shp <- st_as_sf(shp_st)
  
  shpSmall <- shp %>% select(NAME_1, geometry) %>% 
    group_by() %>% 
    mutate(coord = geometry %>% map(.f = function(m) flatten(.x=m)),
           region = row_number()) %>% 
    unnest
  st_geometry(shpSmall) <- NULL
  shpSmall <- shpSmall %>% mutate(coord = coord %>% map(.f = function(m) as_tibble(m)),
                                group = row_number()) %>% 
    unnest %>% 
    setNames(c("name", "region","group", "long", "lat"))

  return(shpSmall) 
}

plot_shpSmall <- function(shpSmall){
  package_required <- c("ggplot2")
  for (packages_name in package_required) {
    if(!is.element(packages_name, installed.packages()[])){
      install.packages(packages_name)
    }
    else {print(paste(packages_name,"library already installed"))}
  }
  sapply(package_required, require, character.only=TRUE)
plotMap <- shpSmall %>% ggplot(aes(x = long, y = lat, group = group)) + 
  geom_polygon(color = "black")
print(plotMap)
}

dsn <- "data/gadm36_CAN_shp/gadm36_CAN_1.shp"
shpSmall <- shpBigToSmall(dsn)
plot_shpSmall(shpSmall)
