

# Source: Datasets from AGUA DE HONDURAS 
# URL: https://aguadehonduras.gob.hn/descargas.php
# Source: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/QET5UQ

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, ggrepel, rgeos, gtools, rgeos, stringr, glue, geodata, elevatr, sf, giscoR, marmap, dismo)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------

# Time series (Historical)
hstr <- dir_ls('data/climate/folder/02. historical_monthly_ts_30s_tif/monthly_ts') %>% 
  map(dir_ls) %>%
  map(as.character) %>% 
  flatten() %>% 
  unlist()

vars <- basename(hstr) %>% str_sub(., 1, 4) %>% unique()

prec <- grep('prec', hstr, value = T)
tmax <- grep('tmax', hstr, value = T)
tmin <- grep('tmin', hstr, value = T)

# Get the years
year <- basename(hstr) %>% 
  str_split(., pattern = '_') %>% 
  map(2) %>% 
  unlist() %>% 
  unique()

# To calculate bioclimatic variables --------------------------------------
# Function and a cycle

purrr::map(.x = 1:length(year), .f = function(i){
  
  cat(year[i], '\n')
  yea <- year[i]
  ppt <- grep(yea, prec, value = T) %>% mixedsort() %>% stack()
  tmx <- grep(yea, tmax, value = T) %>% mixedsort() %>% stack()
  tmn <- grep(yea, tmin, value = T) %>% mixedsort() %>% stack()
  
  bio <- dismo::biovars(prec = ppt, tmax = tmx, tmin = tmn)
  terra::writeRaster(x = bio, filename = glue('results/tif/bioc_{yea}.tif'), overwite = TRUE)
  return(bio)
  
})

# Check the results  ------------------------------------------------------
bioc <- dir_ls('results/tif') %>% as.character()
bioc_1990 <- grep('1990', bioc, value = T) %>% terra::rast()
nlyr(bioc_1990)
names(bioc_1990) <- paste0('bioc_', 1:19)

