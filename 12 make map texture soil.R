

# Load libraries ----------------------------------------------------------
require(pacman)
pacman::p_load(ggspatial, terra, sf, fs, tidyverse, ggrepel, rgeos, gtools, rgeos, stringr, glue, geodata, elevatr, sf, giscoR, marmap, dismo)

g <- gc(reset = T)
rm(list = ls())
options(scipen = 999, warn = -1)

# Load data ---------------------------------------------------------------
txtr <- terra::rast('results/tif/texture/texture_atlantida.tif')
hnd1 <- geodata::gadm(country = 'HND', level = 0, path = 'tmpr')
hnd2 <- geodata::gadm(country = 'HND', level = 1, path = 'tmpr')
atlt <- terra::vect('gpkg/atlantida_proj.gpkg')
atlt <- st_as_sf(atlt)

hnd2 <- st_as_sf(hnd2)
hnd2 <- st_transform(x = hnd2, crs = crs(atlt))

# To read the table -------------------------------------------------------
tble <- qs::qread('results/qs/texture_atlantida.qs')
lvls <- unique(tble$name)

tble <- mutate(tble, name = factor(name, levels = lvls))

crs(txtr)
crs(txtr)

atlt <- hnd2[hnd2$NAME_1 == 'Atlántida',]

# To make the map ---------------------------------------------------------
gmap <- ggplot() + 
  geom_tile(data = tble, aes(x = x, y = y, fill = name)) + 
  scale_fill_viridis_d() + 
  geom_sf(data = hnd2, fill = NA, col = 'grey40', lwd = 0.3) +
  coord_sf(xlim = ext(atlt)[1:2], ylim = ext(olan)[3:4]) + 
  ggtitle(label = 'Textura para Olancho según el método USDA') +
  labs(x = 'Lon', y = 'Lat', fill = 'Textura', caption = 'Fuente: Dataverse') +
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

gmap
ggsave(plot = gmap, filename = 'png/maps/texture.png', units = 'in', width = 9, height = 7, dpi = 300)



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

