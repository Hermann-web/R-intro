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

# extract day and hour
first_date <- heetch_points$location_at_local_time[1]
  # create 2 columns (day, hour)
heetch_points$day <- day(heetch_points$location_at_local_time)
heetch_points$hour <- hour(heetch_points$location_at_local_time)
head(heetch_points)
nrow(heetch_points)
length(heetch_points) #lenght ici c'est nb_col because it is an object like in js

# extract data on the first day
  # method 1
heetch_day1 <- heetch_points %>% 
                filter(day == 1)
heetch_sample <- heetch_day1
heetch_sample
  #method 2
list_index <- sample(x=1:nrow(heetch_points), size=3000, replace=FALSE) #nrows not lenghts
#heetch_sample <- heetch_points[list_index,]
#str(heetch_sample)

#plot(heetch_sample$geometry)  
plot(heetch_sample$geometry, pch=21, cex=0.4) #parametrer le symbole et sa taille


# groupby
ff <- heetch_sample %>% 
  st_drop_geometry() %>% #remove manually the "columns" geometry because you can't remove it from an sf
  select(driver_id, day, hour) %>% 
  group_by(day) %>%  #groupby
  summarise(NB=n()) %>%  #count by defining a columns NB
  filter(NB>30) %>% 
  arrange(NB)
class(ff)
str(ff)
nrow((ff))
head(ff)


# do a grid for aggregation 
casa_grid = st_make_grid(casaBound,
                         #cellsize = 1000, #mile au us et metre ailleurs
                         n = c(50,60)
                         ) # une grille sur l'emprise de casabound #un obj sf
plot(casa_grid) # plot the grid
plot(casaBound$geometry, add=TRUE) # add another plot 
class(casa_grid) 
# count the nb the point per cell
  # method 1: est-ce que les cellules(carreaux) contiennent les points
inter_grid = st_contains(x = casa_grid, y=heetch_sample) #la grille et les points 
inter_grid[72] #le carreau 72 est vide
inter_grid[73] #il va afficher les indexations des points: 882
ii <- inter_grid[73]
ii


# create dataframe (cell_id, nb_of_points, geometry_of_the_cell)
list_lengths_per_cell = sapply(X = inter_grid, FUN = length)
casagrid_points = st_sf(ID_GRID = 1:100,
                        NB_POINTS = list_lengths_per_cell,
                        geometry = casa_grid)
casagrid_points
class(casagrid_points) #un obj sf et dataf --> cartographiable

#suite 
  # voir les densites de points
  # ds vitesses moyennes, tout ce qui resume de l'information
  # travailler sur des troncons plutot que tous les points des routes

# create a carto ---
  # beaucoup de carreux en mers (avec nb_points=0) et ça etire la distribution
casagrid_points_crop = casagrid_points %>% filter(NB_POINTS > 0)
mf_map(x = casaBound,
        type = "base")
mf_map(x=casagrid_points_crop,
       var = "NB_POINTS",
       type = "choro",
       #10 classes d'effectifs egaux pour eviter les pb lies aux outiliers
       breaks = "quantile",
       nbreaks = 10,
       pal = rev(hcl.colors(n=10, palette = "Blues")), #un rev pour fnoce rle pire
       add = TRUE
       ) 

hist(casagrid_points$NB_POINTS)

# projection et distance #le 4326, c'est un system en 3 dim avec les angles (longitude, latitud)
  # identifier le system initial pour pouvoir le transformer #les deux sont du 4326 donc (longitude, latitude)
st_crs(casaBound)
st_crs(heetch_points)

  # project into another projection ststem #attention (longit,ltit) -> (x,y)
heetchpoints_projected <-  st_transform(x=heetch_points, crs=26191)
class(heetchpoints_projected)
head(heetchpoints_projected)

  # get a subset of the heetpoints to compute distances
    #compute distance from all points to all points (1->2, 1->3, 3->1, ....)
mini_heetch = head(heetchpoints_projected, n=4)
matric_distances_all_points_to_all_points <- st_distance(x=mini_heetch, y=mini_heetch)
matric_distances_all_points_to_all_points #c'est en m
units(matric_distances_all_points_to_all_points) <- "km" #transformer en km

    #compute along a road (x[1]->y[1], 1->2, 2->3, 3->4, ....)
matric_distances_point_to_point  <- st_distance(x=mini_heetch[1:3,], y=mini_heetch[2:4,], by_element = TRUE)
matric_distances_point_to_point #

    # compute time laps 
timelaps_point_to_point  <- mini_heetch$location_at_local_time[2:4] - mini_heetch$location_at_local_time[1:3]
timelaps_point_to_point #

  # compute "vitesse"
speed_point_to_point <- matric_distances_point_to_point/timelaps_point_to_point
speed_point_to_point
