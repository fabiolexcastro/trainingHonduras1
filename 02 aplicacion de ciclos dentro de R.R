
# Fabio Alexander Castro Llanos 
# Msc. GIS - Geógrafo
# f.castro@cgiar.org
# Alliance Bioversity - CIAT

# Uso de ciclos dentro de R - algunos ejemplos clásicos

# Ciclo basico
for(i in 1:5){
  print(i)
}

for(j in 1:10){
  print(j * 2)
}

for(k in 2:10){
  print(k * -1)
}

# Uso de lapply
lapply(1:10, function(i){
  cat(i,'\n')
  return(i)
})

lapply(1:10, function(i){
  cat(i, '\t')
  return(i + 100)
})

# Cargar data

nottem <- read.csv('data/tbl/nottem.csv')

# Calculo del promedio por año, esto como ejemplo para identificar
avrg <- NA
year <- nottem$Year

for(i in 1:length(year)){
  
  print(year[i])
  vls <- nottem[which(nottem$Year == year[i]),]
  vls <- ts(vls[,2:ncol(vls)])
  avrg[i] <- mean(vls)
  cat('Done!\n')
  
}

avrg <- data.frame(Year = year, Average = avrg)
write.csv(avrg, 'data/tbl/nottem_avrg.csv', row.names = FALSE)

