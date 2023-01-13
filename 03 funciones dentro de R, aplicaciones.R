

rm(list = ls())

# Source: https://www.kaggle.com/georgesaavedra/covid19-dataset
# Source: nottem (datasets) Average montly temperatures at Nottingham 1920-1939

nottem <- read.csv('data/tbl/nottem.csv')

# Crear una función para el cálculo del promedio por año ------------------
calc_avrg <- function(year){
  tble <- nottem[which(nottem$Year == year),]
  mtrx <- tble[,2:ncol(tble)]
  avrg <- mean(t(mtrx)[,1])
  return(avrg)
}

rslt <- list()
years <- 1920:1939
for(i in 1:length(years)){
  rslt[[i]] <- calc_avrg(year = years[i])
}
rslt <- unlist(rslt)
rslt <- data.frame(year = years, average = rslt)

write.csv(rslt, 'data/tbl/nottem_avrg.csv', row.names = FALSE)

# Crear una función para convertir de fahrenheit a celcius ----------------
# (°F - 32) / 1.8 = °C
convert_celcius <- function(year){
  print(year)
  tble <- nottem[which(nottem$Year == year),]
  mtrx <- tble[,2:ncol(tble)]
  rslt <- t(as.data.frame(apply(mtrx, 2, function(x) (x - 32) / 1.8)))
  rslt <- cbind(tble$Year, rslt)  
  rownames(rslt) <- year
  return(rslt)
}

clss <- list()
for(i in 1:length(years)){
  clss[[i]] <- convert_celcius(year = years[i])
}
clss <- do.call(what = 'rbind', args= clss)
write.csv(clss, 'data/tbl/nottem_celcius.csv', row.names = FALSE)


# Uso de condicionales ----------------------------------------------------

# Basico
x <- 3
x <- -3

if(x > 0){
  print('Valor es positivo')
} else {
  print('Valor es negativo')
}

# Otro ejemplo 
x <- 40.6
type <- 'F'

x <- 23.9
type <- 'C'

if(type == 'F'){
  print('Fahrenheit to celcius')
  c <- (x - 32)/ 1.8
  print(c)
} else {
  print('Celcius to fahrenheit')
  f <- (x * 1.8) + 32
  print(f)
}











