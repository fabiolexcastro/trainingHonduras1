

# Source: Datasets from AGUA DE HONDURAS 
# URL: https://aguadehonduras.gob.hn/descargas.php
# Source: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/QET5UQ

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, rgeos, gtools, rgeos, stringr, glue, geodata)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
fles <- dir_ls(path = 'data/climate/folder/HND') %>% as.character()
hnd0 <- geodata::gadm(country = 'HND', level = 0, path = 'tmpr')
hnd1 <- geodata::gadm(country = 'HND', level = 1, path = 'tmpr')

# Historical --------------------------------------------------------------

# Precipitation
prec <- grep('prec', fles, value = T) %>% grep(paste0(1:12, collapse = '|'), ., value = T) %>% mixedsort() %>% rast()
plot(prec[[1]])

# T max 
tmax <- grep('tmax', fles, value = T) %>% grep(paste0(1:12, collapse = '|'), ., value = T) %>% mixedsort() %>% rast()

# T avg
tavg <- grep('tmea', fles, value = T) %>% grep(paste0(1:12, collapse = '|'), ., value = T) %>% mixedsort() %>% rast()

# T min
tmin <- grep('tmin', fles, value = T) %>% grep(paste0(1:12, collapse = '|'), ., value = T) %>% mixedsort() %>% rast()

# Extract by mask for Olancho ---------------------------------------------
olan <- hnd1[hnd1$NAME_1 == 'Olancho',]

prec_olan <- terra::crop(prec, olan) %>% terra::mask(., olan)
tmax_olan <- terra::crop(tmax, olan) %>% terra::mask(., olan)
tmin_olan <- terra::crop(tmin, olan) %>% terra::mask(., olan)
tavg_olan <- terra::crop(tavg, olan) %>% terra::mask(., olan)

# Calculate average and a sum to the rasters ------------------------------
prec_olan <- sum(prec_olan)
tmax_olan <- mean(tmax_olan)
tmin_olan <- mean(tmin_olan)
tavg_olan <- mean(tavg_olan)

# Write these rasters  ----------------------------------------------------
dout <- 'data/climate/folder/Olancho'
dir.create(dout, recursive = TRUE)

terra::writeRaster(x = prec_olan, filename = paste0(dout, '/', 'prec_sum.tif'), overwrite = T)
terra::writeRaster(x = tmax_olan, filename = paste0(dout, '/', 'tmax_avg.tif'), overwrite = T)
terra::writeRaster(x = tmin_olan, filename = paste0(dout, '/', 'tmin_avg.tif'), overwrite = T)
terra::writeRaster(x = tavg_olan, filename = paste0(dout, '/', 'tavg_avg.tif'), overwrite = T)



