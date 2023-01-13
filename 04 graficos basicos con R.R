

rm(list = ls())

# Source: nottem (datasets) Average montly temperatures at Nottingham 1920-1939

library(pacman)
p_load(tidyverse, ggplot2)

# Read the data -----------------------------------------------------------
nottem <- read.csv('data/tbl/nottem.csv')
class(nottem)

# Scatter plot ------------------------------------------------------------
plot(nottem$Year, nottem$Jan)
plot(nottem$Year, nottem$Jan, main = 'Temperatura para enero desde 1920 hasta 1939', col = 'blue', xlab = 'Año', ylab = 'Temperatura', pch = 16)

# Line plot ---------------------------------------------------------------
plot(nottem$Year, nottem$Jan, type = 'l')
plot(nottem$Year, nottem$Jan, type = 'l', main = 'Temperatura para enero desde 1920 hasta 1939', col = 'blue', xlab = 'Año', ylab = 'Temperatura')

# Barplot -----------------------------------------------------------------
barplot(nottem$Jan)
barplot(nottem$Jan, names.arg = nottem$Year, las = 2, cex.names = 1.1, main = 'Temperatura para enero desde 1920 hasta 1939', col = 'grey90')

# Boxplot -----------------------------------------------------------------
library(tidyverse)
nottem_gather <- gather(nottem, month, value, -Year)
boxplot(nottem_gather$value ~ nottem_gather$month)

nottem_gather$month <- factor(nottem_gather$month, levels = month.abb)

boxplot(nottem_gather$value ~ nottem_gather$month)
# Mejorando....
boxplot(nottem_gather$value ~ nottem_gather$month, main = 'Temperatura promedio desde 1920 hasta 1939', col = 'grey70', xlab = 'Mes', ylab = 'Temperatura (F)')








