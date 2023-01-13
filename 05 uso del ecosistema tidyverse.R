
rm(list = ls())

# Source: nottem (datasets) Average montly temperatures at Nottingham 1920-1939

# Install packages and load these libraries
install.packages('pacman')
library(pacman)
pacman::p_load(tidyverse, stringr)

# Load data
nottem <- read_csv('data/tbl/nottem.csv')
nottem

# Seleccionar columnas
nottem_sub <- dplyr::select(nottem, Year, Jan, Feb, Mar, Apr, May, Jun)

# Add the average
head(nottem)
nottem <- mutate(nottem, average_1 = (Jan + Feb + Mar + Apr + May + Jun + Jul + Aug + Sep + Oct + Nov + Dec)/12)
nottem <- mutate(nottem, average_2 = apply(nottem[,2:13], 1, 'mean'))
nottem <- mutate(nottem, average_3 = rowMeans(x = nottem[,2:13]))

# Check the columns types -------------------------------------------------
str(nottem)
glimpse(nottem)

# Filtering ---------------------------------------------------------------
nottem_1925 <- filter(nottem, Year == 1925)
nottem_1930_1940 <- filter(nottem, Year %in% 1930:1940)

# Transpose ---------------------------------------------------------------
nottem <- dplyr::select(nottem, Year:Dec)
nottem_gather <- gather(nottem, year, value, -Year)
nottem_gather

# Spread ------------------------------------------------------------------
nottem_spread <- nottem_gather %>% spread(key = year, value = value)
write.csv(nottem_gather, 'data/tbl/nottem_gather.csv', row.names = FALSE)



