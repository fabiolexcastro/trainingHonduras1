


# Fabio Alexander Castro Llanos 
# Msc. GIS - Geógrafo
# f.castro@cgiar.org
# Alliance Bioversity - CIAT

# Descarga de información de cambio climático según datos del sexto informe del IPCC

# Carga de librerías
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, rgeos, gtools, rgeos, stringr, glue, geodata)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Parámetros 
ssps <- c(126, 245, 370, 585)
prds <- c('2021-2040', '2041-2060', '2061-2080')
vars <- c('tmin', 'tmax', 'prec')
mdls <- c("ACCESS-CM2", "ACCESS-ESM1-5", "AWI-CM-1-1-MR", "BCC-CSM2-MR", "CanESM5", "CanESM5-CanOE", "CMCC-ESM2", "CNRM-CM6-1", "CNRM-CM6-1-HR", "CNRM-ESM2-1", "EC-Earth3-Veg", "EC-Earth3-Veg-LR", "FIO-ESM-2-0", "GFDL-ESM4", "GISS-E2-1-G", "GISS-E2-1-H", "HadGEM3-GC31-LL", "INM-CM4-8", "INM-CM5-0", "IPSL-CM6A-LR", "MIROC-ES2L", "MIROC6", "MPI-ESM1-2-HR", "MPI-ESM1-2-LR", "MRI-ESM2-0", "UKESM1-0-LL")

# Ejemplo de descarga de un modelo 
prec <- cmip6_tile(lon = -87, lat = 12, model = mdls[1], ssp = ssps[1], time = prds[1], var = 'prec', path = 'tmpr')
tmax <- cmip6_tile(lon = -87, lat = 12, model = mdls[1], ssp = ssps[1], time = prds[1], var = 'tmax', path = 'tmpr')
tmin <- cmip6_tile(lon = -87, lat = 12, model = mdls[1], ssp = ssps[1], time = prds[1], var = 'tmin', path = 'tmpr')

# Descarga de datos politico administrativos 
hnd0 <- geodata::gadm(country = 'HND', level = 0, path = 'tmpr')
plot(prec[[1]])
plot(hnd0, add = T, border = 'green')

# Extraccion por máscara
prec <- terra::crop(prec, hnd0)
prec <- terra::mask(prec, hnd0)
plot(prec[[1]])


