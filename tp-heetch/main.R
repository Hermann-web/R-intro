###################################
### Projet d'analyse VTC Heetch ###
###################################

# load packages ----
library(dplyr)
library(sf)
library(leaflet)

# load data  ----
casaBound <- st_read("data/casabound.geojson") #des poinrts qui forment une
plot(casaBound$geometry)#un plot de la géométrie

# whatever ----
