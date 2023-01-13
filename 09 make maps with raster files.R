
# Source: Datasets from AGUA DE HONDURAS 
# URL: https://aguadehonduras.gob.hn/descargas.php
# Source: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/QET5UQ

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(terra, sf, fs, tidyverse, ggrepel, rgeos, gtools, rgeos, stringr, glue, geodata, elevatr, sf, giscoR, marmap)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
fles <- dir_ls('data/climate/folder/Olancho') %>% as.character()
prec <- grep('prec', fles, value = T) %>% 
  terra::rast()

# Podemos crear una función para apilar el paso 16 y 17 dentro de uno solo
rdrs <- function(x){grep(x, fles, value = T) %>% terra::rast()}
prec <- rdrs('prec')
tmax <- rdrs('tmax')
tmin <- rdrs('tmin')
tavg <- rdrs('tavg')             

names(prec) <- 'prec'
names(tmax) <- 'tmax'
names(tmin) <- 'tmin'
names(tavg) <- 'tavg'

# Download  ---------------------------------------------------------------
hnd1 <- geodata::gadm(country = 'HND', level = 1, path = 'tmpr')
hnd2 <- geodata::gadm(country = 'HND', level = 2, path = 'tmpr')
olan <- hnd1[hnd1$NAME_1 == 'Olancho',]
mpio <- hnd2[hnd2$NAME_1 == 'Olancho',]

# Convert to sf
hnd1 <- st_as_sf(hnd1)
olan <- st_as_sf(olan)
mpio <- st_as_sf(mpio)

p_load(rnaturalearthdata, rnaturalearth, RColorBrewer, ggspatial)

wrld <- ne_countries(returnclass = 'sf', scale = 50)

# Raster to table ---------------------------------------------------------
stck <- c(prec, tmax, tmin, tavg)
plot(stck)

tble <- terra::as.data.frame(x = stck, xy = T) %>% as_tibble()

# Divide temperature by 10
tble <- tble %>% mutate_at(vars(matches('t')), function(x){x/10})

# To make precipitation map -----------------------------------------------
windowsFonts(georg = windowsFont('Georgia'))

hcl.pals() # Check the colors: https://developer.r-project.org/Blog/public/2019/04/01/hcl-based-color-palettes-in-grdevices/  

clrs <- hcl.colors(7, "Earth")
clrs <- brewer.pal(n = 9, name = 'BrBG')

gppt <- ggplot() + 
  geom_tile(data = tble, aes(x = x, y = y, fill = prec)) + 
  scale_fill_gradientn(colors = clrs, breaks = c(1250, 1500, 1750, 2000, 2250, 2500), labels = c(1250, 1500, 1750, 2000, 2250, 2500)) + # brewer.pal(n = 9, name = 'BrBG')
  geom_sf(data = olan, fill = NA, col = 'grey40', lwd = 0.4) +
  geom_sf(data = hnd1, fill = NA, col = 'grey50', lwd = 0.2) +
  geom_sf(data = mpio, fill = NA, col = 'grey70', lwd = 0.2) +
  labs(x = 'Lon', y = 'Lat', fill = 'Precipitación (mm)', 
       caption = 'Adaptado de:\nNavarro Racines, Carlos E.; Llanos Herrera, Lizeth; Monserrate, Fredy, 2018,\n30-seconds (1 Km2) monthly, seasonal and annual gridded Historical Climate Surfaces for Honduras.') +
  coord_sf(xlim = ext(olan)[1:2], ylim = ext(olan)[3:4]) + 
  ggtitle(label = 'Precipitación acumulada para el departamento de Olancho\nen Honduras', 
          subtitle = '1981-2010') +
  theme_minimal() +
  theme(legend.position = 'bottom',
        plot.title = element_text(face = 'bold', hjust = 0.5, color = 'grey50'),
        plot.subtitle = element_text(color = 'grey50', hjust = 0.5, vjust = 0),
        axis.title = element_text(face = 'bold'),
        text = element_text(family = 'georg', color = 'grey50'),
        axis.text.y = element_text(hjust = 0.5, angle = 90, size = 6),
        plot.caption = element_text(hjust = 0.5),
        axis.text.x = element_text(size = 6),
        legend.key.width = unit(4, 'line')) +
  guides(fill = guide_legend( 
    direction = 'horizontal',
    keyheight = unit(1.15, units = "mm"),
    keywidth = unit(15, units = "mm"),
    title.position = 'top',
    title.hjust = 0.5,
    label.hjust = .5,
    nrow = 1,
    byrow = T,
    reverse = F,
    label.position = "bottom"
  )) +
  annotation_scale(location =  "bl", width_hint = 0.5, text_family = 'georg', text_col = 'grey60', bar_cols = c('grey60', 'grey99'), line_width = 0.2) +
  annotation_north_arrow(location = "tr", which_north = "true", 
                         pad_x = unit(0.1, "in"), pad_y = unit(0.2, "in"), 
                         style = north_arrow_fancy_orienteering(text_family = 'georg', text_col = 'grey40', line_col = 'grey60', fill = c('grey60', 'grey99'))) 

gppt

ggsave(plot = gppt, filename = 'png/maps/prec_olancho_baseline.png', units = 'in', width = 9, height = 7, dpi = 300) # scale_fill_etopo


