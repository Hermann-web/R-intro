################################## #
### Projet d'analyse VTC Heetch ## #
################################## #

# load packages ----
library(dplyr)
library(sf) #données géométriques
library(leaflet) #visualisation
library(lubridate) #work with times

# load data  ----
  # 
casaBound <- st_read("data/casabound.geojson") #des poinrts qui forment une
plot(casaBound$geometry)#un plot de la géométrie
class(casaBound)
str(casaBound)

  # un object spatial "simple features"
osmFeatures <- readRDS("data/osmfeatures.Rds") 
class(osmFeatures)
str(osmFeatures)

# load hetchpoints (a simple feature)
heetch_points <- readRDS("data/heetchmarchcrop.Rds") #too much data
head(heetch_points) #(driver_id, location_at_local_time, geometry)
class(heetch_points)
str(heetch_points)

# carte de la geometrie des routes ----
plot(casaBound$geometry, border="black")
plot(osmFeatures$roads$geometry, add=TRUE, col="grey")
plot(osmFeatures$tramway$geometry, add=TRUE, col="green")
plot(osmFeatures$tramstop$geometry, add=TRUE, col="black")


# afficher les tuiles ----
# on peut regler des couleurs, des 
leaflet() %>%
  # addTiles() #tuile de base
  addProviderTiles("Stamen.TonerLite") %>% #tuile particulieres
  addPolylines(data=osmFeatures$tramway, color="red") %>%
  addCircles(data = osmFeatures$tramstop, 
             color = "black",
             label = osmFeatures$tramstop$name) %>%
  addCircles(data = heetch_points[1:10,], 
             color = "blue"
             )

# count nb of drivers ----
nb_drivers <- heetch_points$driver_id %>% unique() %>% length()
nb_drivers #1309
