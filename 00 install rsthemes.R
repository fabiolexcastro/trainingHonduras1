
# Fabio Alexander Castro Llanos 
# Msc. GIS - Geógrafo
# f.castro@cgiar.org
# Alliance Bioversity - CIAT

# Instalación de distintos temas para RStudio, esto no afecta en nada el funcionamiento de RStudio ni de R. 

install.packages('devtools')
library(devtools)

devtools::install_github("gadenbuie/rsthemes")
library(rsthemes)

rsthemes::install_rsthemes()

# Instalar otros temas
rsthemes::install_rsthemes(include_base16 = TRUE)

# Para instalar nuevas fuentes de texto, se puede visitar la página web nerdfonts.com
# URL
# https://www.nerdfonts.com/font-downloads

# Se instalan las fonts de mayor gusto, y luego se reinicia RStudio, vamos al Global Options, y en la sección 
# de apariencia se puede cambiar el font y el tema
