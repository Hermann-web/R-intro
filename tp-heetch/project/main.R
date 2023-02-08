################################## #
### Projet d'analyse VTC Heetch ## #
################################## #

# load packages ----
library(dplyr)
library(sf) #données géométriques
library(leaflet) #visualisation
library(lubridate) #work with times
library(mapsf) #as leaflet but static

# load data  ----
# 
casaBound <- st_read("data/casabound.geojson") #des poinrts qui forment une
plot(casaBound$geometry)#un plot de la géométrie
class(casaBound)
head(casaBound)

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

# les donnes sont reccuperes quand l'appli est allumée 
# - pas quand l'appli est fermée
# - oui le chauffeur se repose, attends qu'on l'apelle


# nb chauffeur = 
# representer des deplacements

# agregations 

# prendre un jour, un chauffeur

one_driver <- 
heetch_points$location_at_local_time[1] - heetch_points$location_at_local_time[0]

