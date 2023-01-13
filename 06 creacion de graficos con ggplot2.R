
rm(list = ls())


library(pacman)
p_load(tidyverse, ggplot2)

rm(list = ls())

# Font --------------------------------------------------------------------
windowsFonts(georg = windowsFont('Georgia'))

# Load data ---------------------------------------------------------------
nottem <- read_csv('data/tbl/nottem.csv')
nottem <- nottem %>% gather(month, value, -Year)

# Month as factor ---------------------------------------------------------
nottem <- mutate(nottem, month = factor(month, levels = month.abb))

# Filtering 1920
nottem_1920 <- filter(nottem, Year == 1920)
nottem_1920

# Lineplot -----------------------------------------------------------------

glne_1920 <- ggplot(data = nottem_1920, aes(x = month, y = value, group = 1)) + 
  geom_line(size = 1.2, col ='grey50')
glne_1920

glne_1920 <- 
  glne_1920 + 
  labs(x = 'Meses', y = 'Temperatura (F)', caption = 'Fuente: Anderson, O. D. (1976) Time Series Analysis and Forecasting') + 
  scale_x_discrete(labels = c('Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic')) +
  ggtitle(label = 'Temperatura para 1920 en Nottingham (Inglaterra)') +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, color = 'grey40', face = 'bold'), 
        plot.caption = element_text(hjust = 0.5, color = 'grey30'), 
        axis.text.x = element_text(color = 'grey40'), 
        axis.text.y = element_text(color = 'grey40'), 
        text = element_text(family = "georg"),
        axis.title = element_text(face = 'bold', color = 'grey40')) + 
  geom_point()

glne_1920

dir.create('png/graphs', recursive = T)
ggsave(plot = glne_1920, filename = 'png/graphs/line_1920_temperature.png', units = 'in', width = 7, height = 5, dpi = 300)

# A boxplot ---------------------------------------------------------------

nottem
nottem_jan <- filter(nottem, month == 'Jan')

gbox_jan <- ggplot(data = nottem_jan, aes(y = value)) + 
  geom_boxplot(group = 1, fill = 'grey40') + 
  labs(x = '', y = 'Temperatura (F)', caption = 'Fuente: Anderson, O. D. (1976) Time Series Analysis and Forecasting') +
  ggtitle(label = 'Temperatura para todos los eneros desde 1920 hasta el 1939') +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, color = 'grey40', face = 'bold'), 
        plot.caption = element_text(hjust = 0.5, color = 'grey30'), 
        axis.text.x = element_blank(), 
        axis.text.y = element_text(color = 'grey40'), 
        text = element_text(family = "georg"),
        axis.title = element_text(face = 'bold', color = 'grey40'))
gbox_jan

gbox_all <- ggplot(data = nottem, aes(y = value, x= month, group = month, fill = month)) + 
  geom_boxplot() +
  scale_fill_viridis_d() +
  labs(x = '', y = 'Temperatura (F)', fill = 'Mes', caption = 'Fuente: Anderson, O. D. (1976) Time Series Analysis and Forecasting') +
  ggtitle(label = 'Temperatura para todos los meses') +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5, color = 'grey40', face = 'bold'), 
        plot.caption = element_text(hjust = 0.5, color = 'grey30'), 
        axis.text.x = element_text(color = 'grey40'), 
        axis.text.y = element_text(color = 'grey40'), 
        text = element_text(family = "georg"),
        axis.title = element_text(face = 'bold', color = 'grey40'))
gbox_all

ggsave(plot = gbox_jan, filename = 'png/graphs/boxplot_enero_temperature.png', units = 'in', width = 7, height = 5, dpi = 300)
ggsave(plot = gbox_all, filename = 'png/graphs/boxplot_all_temperature.png', units = 'in', width = 7, height = 5, dpi = 300)



