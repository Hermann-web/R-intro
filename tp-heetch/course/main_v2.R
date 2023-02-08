################################## #
### Projet d'analyse VTC Heetch ## #
################################## #

# load packages ----
library(dplyr)
library(sf) #données géométriques
library(leaflet) #visualisation
library(lubridate) #work with times
library(mapsf) #as leaflet but static
library(tidyr) #gerer les convestion de table: long to matric_carre

# load data  ----
casaBound <- st_read("data/casabound.geojson") #des poinrts qui forment une
# un object spatial "simple features"
osmFeatures <- readRDS("data/osmfeatures.Rds") 
# load hetchpoints (a simple feature)
heetch_points <- readRDS("data/heetchmarchcrop.Rds") #too much data
# load neigbors
casa_neib <- st_read("data/casaneib.geojson")
head(casa_neib)

# project all data ----
proj_crs <- 26191 #code de la proj nord maroc
casaBound_proj = st_transform(casaBound, crs=proj_crs)
heetch_points_proj = st_transform(heetch_points, crs=proj_crs)
casa_neib_proj = st_transform(heetch_points, crs=proj_crs)
rm(proj_crs)

# plot data ----
#casaBound
plot(casaBound_proj$geometry)#un plot de la géométrie
class(casaBound_proj)
str(casaBound_proj)
head(casaBound_proj)

rm(casaBound)
rm(heetch_points)
rm(casa_neib)

#osmFeatures
class(osmFeatures)
str(osmFeatures)


#heetch_points_proj
head(heetch_points_proj) #(driver_id, location_at_local_time, geometry)
class(heetch_points_proj)
str(heetch_points_proj)

# carte de la geometrie des routes ----
plot(casaBound_proj$geometry, border="black")
plot(osmFeatures$roads$geometry, add=TRUE, col="grey")
plot(osmFeatures$tramway$geometry, add=TRUE, col="green")
plot(osmFeatures$tramstop$geometry, add=TRUE, col="black")

# filter heechpoints t oget "01/03"
# create 2 columns (day, hour)
heetch_points_proj$day <- day(heetch_points_proj$location_at_local_time)
heetch_points_proj$hour <- hour(heetch_points_proj$location_at_local_time)
head(heetch_points_proj)
nrow(heetch_points_proj)
length(heetch_points_proj) #lenght ici c'est nb_col because it is an object like in js

# extract data on the first day
# method 1
heetch_day1 <- heetch_points_proj %>% 
  filter(day == 1)
heetch_sample <- heetch_day1
rm(heetch_day1)
heetch_sample

# inteesecter les points et leurs quartiers
  # methode 1 #avec defaut
points_in_neighbors <- st_within(x=heetch_sample, y=casa_neib_proj) %>% unlist()
points_in_neighbors #liste de nombres: chaque point(pos) et son quartier(nombre)
length(points_in_neighbors)#166392 au lieu de 166259=nrow(heetch_sample). 100 points de plus à cause de l'approximation 

  #methode 2: find points in casa then filter
casa_neib_union <- st_union(casa_neib_proj)
select_points_in_casa <- st_contains(x=casa_neib_union, y=heetch_sample) %>% unlist()
rm(casa_neib_union)
length((select_points_in_casa))
select_points_in_casa #liste des points de casa 
heetch_sample_crop <- heetch_sample[select_points_in_casa,]
rm(select_points_in_casa)
rm(heetch_sample)
points_in_neighbors <- st_within(x=heetch_sample_crop, y=casa_neib_proj) %>% unlist()
points_in_neighbors #liste de nombres: chaque point(pos) et son quartier(nombre)
length(points_in_neighbors)#166392
heetch_sample_crop$NEIB <- points_in_neighbors
head(heetch_sample_crop)

# agregation
nested_points <- heetch_sample_crop %>% 
  st_drop_geometry() %>% #enlever la geometrie
  group_by(hour, driver_id, NEIB) %>% #classic grouby
  summarise(NB_POINTS=n()) #count
class(nested_points) #hour,driver_id,neib,nb_points
head(nested_points)
nrow(nested_points) #17155



# reorder to find for each driver at each hour, his "quartier"
  #methode 1: il  ua des doublons
main_neib <- nested_points %>% 
  slice_max(order_by = NB_POINTS)
class(main_neib) #hour,driver_id,neib,nb_points
head(main_neib)
nrow(main_neib) #5074
  #methode 2
main_neib <- nested_points %>% 
  group_by(driver_id, hour) %>% 
  arrange(desc(NB_POINTS)) %>% 
  slice(1)
class(main_neib) #hour,driver_id,neib,nb_points
head(main_neib)
nrow(main_neib) #4834

# pivot table to have driver as index and hour as columns
main_neib_pivot <- main_neib %>% 
  tidyr::pivot_wider(names_from = hour,
                     values_from = NEIB,
                     names_prefix="H",
                     values_fill=NA
                     )
class(main_neib_pivot) #NB_POINTS,H22, H21, H20, H19, ...
head(main_neib_pivot)? H
nrow(main_neib_pivot) #4834

