# Objective

# Steps
- download [R](https://cran.r-project.org/) and [R-studio](https://posit.co/download/rstudio-desktop/)
- create a project 
- install packages
- download data from [this link](https://acloud.zaclys.com/index.php/s/ZyXcsF2AgGmMKaJ)
- find the code [here](data/heetch_casablanca.html)
- load data ()
- show the map

# remember
- run: **CTRL ENter**
- autocompletet: **TAB**
- def de varible: **ALT +**
- operateur de chainage: **CTLR SHIFT M**

# read/writes files
- **sf**: st_read()
- **csv**: read.csv(), write.csv()
- **xlsx**: read.xlsx(), write.xlsx() 
- **table**: read.table(), write.table()
- **rds**: readRDS(), writeRDS()

# things
- il y a plusieurs types de geometrie
- tj voir les types des colonnes
- sur le projet, l'info est trop fine. Il faudra mailler (carrouiller) et aggreger avec le package sf
- toutes les fonctions du package sf commencent par st 
- dans R-studio, il y a des cheats
- faire de la cartographie, c'est essentiellement faire de la couleur
- some diff
    - carte statistique: representer visuellement des variations (comme heatmap)
    - cartographie: just plot
- regle de carto
    - l'homme ne distingue que 10,12 nuances d'une même couleur donc discretise les couleurs de ton heatmap, ...
    - check [colorbrewer](https://colorbrewer2.org) pour les palettes de couleurs
    - choix de palette
        - intensite -> palette sequentielle
        - variable categorielle -> palette qualitative
- bons packages de cart
    - mapsf: static
    - tmap: static
    - leaflet: dynamic

# Ressources
- R cheat: [rpubs.com](https://www.rpubs.com/Bentley_87/542213), [iqss.github.io](https://iqss.github.io/dss-workshops/R/Rintro/base-r-cheat-sheet.pdf)
- [view doc on a package](https://cran.r-project.org/web/packages/dplyr/index.html)
- [palette de couleurs sur R](https://blog.r-project.org/2019/04/01/hcl-based-color-palettes-in-grdevices/)
- [maps datasets](https://gadm.org/)
- [openstrretmap](https://www.openstreetmap.org/#map=6/31.885/-7.080)

# questions
- geometrie MULTIPOLYGON; c'est quoi? c'est quoi les autres? 
