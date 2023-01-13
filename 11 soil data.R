

# Source: Datasets from AGUA DE HONDURAS 
# URL: https://aguadehonduras.gob.hn/descargas.php
# Source: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/MBHUV4

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, ggrepel, rgeos, gtools, rgeos, stringr, glue, geodata, elevatr, sf, giscoR, marmap, dismo)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
fles <- dir_ls('data/soils/texture') %>% as.character()

clay <- grep('Clay', fles, value = T) %>% terra::rast()
sand <- grep('Sand', fles, value = T) %>% terra::rast()
silt <- grep('Silt', fles, value = T) %>% terra::rast()

hnd1 <- geodata::gadm(country = 'HND', level = 1, path = 'tmpr')
atlt <- hnd1[hnd1$NAME_1 == 'Atlántida',]
plot(hnd1)
plot(atlt, add = T, col = 'red')

atlt <- terra::project(x = atlt, crs(clay))

writeVector(atlt, filename = 'gpkg/atlantida_proj.gpkg')

# To crop  ----------------------------------------------------------------
clay <- terra::crop(clay, atlt) %>% terra::mask(., atlt)
sand <- terra::crop(sand, atlt) %>% terra::mask(., atlt)
silt <- terra::crop(silt, atlt) %>% terra::mask(., atlt)

# To stack  ---------------------------------------------------------------
stck <- c(clay, sand, silt)
names(stck) <- c('clay', 'sand', 'silt')
tble <- terra::as.data.frame(stck, xy = T)
tble <- as_tibble(tble)
tble <- relocate(tble, x, y, clay, silt, sand)
colnames(tble)[3:5] <- c('CLAY', 'SILT', 'SAND')
tble <- as.data.frame(tble)

# Calculate soil texture https://soilresearchwithr.blogspot.com/2022/05/creating-soil-textural-triangles-in-r.html
# install.packages('soiltexture')
library(soiltexture)

TT.plot()
TT.plot(class.sys = "USDA-NCSS.TT")
TT.classes.tbl(class.sys = "USDA-NCSS.TT")

Tex.class <- TT.points.in.classes(
  tri.data = tble[,3:5],
  class.sys = "USDA-NCSS.TT",
  PiC.type = "t"
)

lbls <- TT.classes.tbl(class.sys = "USDA-NCSS.TT") %>% as_tibble() %>% dplyr::select(1, 2)

# Add the texture class to the dataframe -----------------------------------
tble <- mutate(tble, class = Tex.class)
tble <- as_tibble(tble)
table(tble$class)
tble <- inner_join(tble, lbls, by = c('class' = 'abbr'))
unique(tble$name)

# Silty: limoso; Clay: arcilla; Sandy: arenoso
vles <- tibble(value = 1:7, name = unique(tble$name))
tble <- inner_join(tble, vles, by = c('name' = 'name'))

txtr <- tble[,c(1, 2, 8)]
txtr <- terra::rast(txtr, type = 'xyz')

dir_create('results/tif/texture')
writeRaster(txtr, 'results/tif/texture/texture_atlantida.tif')

# To save -----------------------------------------------------------------
tble
library(qs)

qs::qsave(x = tble, file = 'results/qs/texture_atlantida.qs')
