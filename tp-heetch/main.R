################################## #
### Projet d'analyse VTC Heetch ## #
################################## #

# load packages ----
library(dplyr)
library(sf) 
library(leaflet)

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

# carte de la geometrie des routes ----
plot(casaBound$geometry, border="black")
plot(osmFeatures$roads$geometry, add=TRUE, col="grey")
plot(osmFeatures$tramway$geometry, add=TRUE, col="green")
plot(osmFeatures$tramstop$geometry, add=TRUE, col="black")

# tester le chainage ----
c(123, 50, 18,200) %>% mean() %>% round()

# afficher les tuiles ----
# on peut regler des couleurs, des 
leaflet() %>%
  # addTiles() #tuile de base
  addProviderTiles("Stamen.TonerLite") %>% #tuile particulieres
  addPolylines(data=osmFeatures$tramway, color="red") %>%
  addCircles(data = osmFeatures$tramstop, 
             color = "black",
             label = osmFeatures$tramstop$name)

# load hetchpoints 
heetch_points <- readRDS("data/heetchmarchcrop.Rds")
