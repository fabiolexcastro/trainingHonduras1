
# Source: Datasets from AGUA DE HONDURAS 
# URL: https://aguadehonduras.gob.hn/descargas.php

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, rgeos, gtools, rgeos, stringr, glue)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
fles <- dir_ls('data/shp/cuencas', regexp = '.shp$') %>% as.character()


# Read the shapeifle ------------------------------------------------------

# Cuencas
bsns <- grep('/cuencas.shp', fles, value = T) %>% st_read()
rvrs <- grep('/drenaje_cuencas.shp', fles, value = T) %>% st_read()

plot(st_geometry(bsns), border = 'grey50')
plot(st_geometry(rvrs), col = 'blue', add = TRUE)

# Project the shapefiles to WGS 1984 - Example ----------------------------
bsns_wg84 <- st_transform(bsns, crs = st_crs(4326))
rvrs_wg84 <- st_transform(rvrs, crs = st_crs(4326))

# Calcular la longitud de cada río ----------------------------------------
lngt <- round(as.numeric(st_length(x = rvrs)), 0)
rvrs
rvrs <- mutate(rvrs, length = lngt)

# Convertir a km ----------------------------------------------------------
rvrs <- mutate(rvrs, length = length / 1000, length = round(length, 1))

# Cuál es el rio más largo  -----------------------------------------------
top_n(rvrs, n = 1, wt = length) %>% pull(Cuenca)
print(paste0('El río más largo es: ', pull(top_n(rvrs, n = 1, wt = length), Cuenca)))

# Cual es el rio más corto ------------------------------------------------
top_n(rvrs, n = -1, wt = length)

# Hay un problema, pues el río más largo resulta ser también el -----------
# río más largo, resulta ser el río más corto -----------------------------

table(rvrs$Cuenca) # Hay rios repetidos, hay que agregarlos
rvrs_smpl <- vect(rvrs) %>% terra::aggregate(., 'Cuenca')
table(rvrs_smpl$Cuenca)
rvrs_smpl <- st_as_sf(rvrs_smpl)
plot(st_geometry(rvrs_smpl))

lngt <- round(as.numeric(st_length(x = rvrs_smpl)), 0)
rvrs_smpl <- mutate(rvrs_smpl, length = lngt / 1000, length = round(length, 1))

# Cuál es el río más largo ------------------------------------------------
rvrs_smpl
rvrs_smpl
top_n(rvrs_smpl, n = 1, wt = length)
print(paste0('El río más largo es: ', pull(top_n(rvrs_smpl, n = 1, wt = length), Cuenca)))

# Cuál es el río más corto ------------------------------------------------
top_n(rvrs_smpl, n = -1, wt = length)
print(paste0('El río más corto es: ', pull(top_n(rvrs_smpl, n = -1, wt = length), Cuenca)))

# Download administrative data --------------------------------------------
hnd1 <- geodata::gadm(country = 'HND', level = 1, path = 'tmpr')
hnd1 <- st_as_sf(hnd1)
olan <- filter(hnd1, NAME_1 == 'Olancho')

plot(st_geometry(hnd1))
plot(st_geometry(olan), col = 'red', add = TRUE)

# Cuáles cuencas tiene el departamento de Olancho? ------------------------
bsns_wg84 <- st_make_valid(bsns_wg84)
olan <- st_make_valid(olan)

olan_bsns <- st_intersection(olan, bsns_wg84)

print(paste0('Las cuencas del departamento de Olancho son: ', pull(olan_bsns, Cuenca)))
print(paste0('Las cuencas del departamento de Olancho son: ', paste0(pull(olan_bsns, Cuenca), collapse = ', ')))

# To calculate the buffer -------------------------------------------------
bffr <- rvrs_smpl %>% st_buffer(x = ., dist = 30)
bffr

# How to write ------------------------------------------------------------
st_write(bffr, 'data/gpkg/rivers_buffer.gpkg')
st_write(rvrs_smpl, 'data/gpkg/rivers_simple.gpkg')
st_write(hnd1, 'data/gpkg/honduras_adm1.gpkg')









