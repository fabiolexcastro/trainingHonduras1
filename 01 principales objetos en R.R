
# Fabio Alexander Castro Llanos 
# Msc. GIS - Geógrafo
# f.castro@cgiar.org
# Alliance Bioversity - CIAT

# Principales objetos dentro de R - Usar R como calculadora

# Conociendo objetos dentro de R
v_number <- c(1, 2.4, 2.3, 10)
v_character <- 'Curso de SIG con R para Agua de Honduras'
v_vector <- c('caballo', 'delfin', 'ballena', 'perro', 'gato')
v_integer <- c(1L, 100L, 120L) # La L se utiliza para indicar que el elemento es un entero
v_boolean <- c(TRUE, FALSE, T, F) # Estos objetos son lógicos
u_number <- 2

# Acceder a posiciones dentro de Vectores 
position <- 2
v_vector[position] # Position sería un número entre 
v_vector[3]
v_vector[c(2, 3)]
v_vector[2:3]

# Creacion de listas con distintos tipos de elementos - Listas no nombradas
x <- list(1:5, "Ecocrop Model", c(TRUE, FALSE, TRUE), c(1.5, 2.23), list(1, "a"))
str(x)
x[[2]]
x[[5]][[2]]

# Listas nombradas
x <- list(elem_1 = 1:5, 
          elem_2 = "Eugenio", 
          elem_3 = c(FALSE, TRUE, TRUE, FALSE, TRUE), 
          elem_4 = c(1.5, 2.23), 
          elem_5 = list(1.2, "a")) 

x$elem_1
x$elem_2
x[[2]]

# Acceder a las posiciones dentro de una lista 
x[[2]] # A diferencia del vector, para acceder a una ubicacion dentro de la lista se usan dos corchetes [[]]

# Creacion de dataframe 
gastos <- data.frame(meses = c('Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'),
                     ventas_a = rnorm(12, mean = 300, sd = 23), 
                     ventas_b = rnorm(12, mean = 340, sd = 34),
                     ventas_c = rnorm(12, mean = 400, sd = 20))

# Características de un dataframe
dim(gastos) # Filas y columnas
nrow(gastos) # Número de filas
ncol(gastos) # Número de columnas 

# Acceder a las filas dentro de un dataframe
numero_fila <- 5
gastos[numero_fila,]

# Acceder a las filas dentro de una columna 
numero_columna <- 2
gastos[,numero_columna]

# Acceder a varias filas y columnas 
gastos_ene_nov <- gastos[c(1, 11), c('meses', 'ventas_c')]

# Creacion de matrix 
m_matrix <- matrix(c(0.2, 0.3, 0.5, 0.2, 0.6, 0.7, 0.9, 1.1, 1.4), 
                   byrow = T, nrow = 3, ncol = 3)

as.matrix(gastos)

# Conocer el tipo de clase de un objeto 
class(x)
class(m_matrix)
class(v_vector)
class(x)
class(gastos)

# La function typeof devuelve una cadena de caracterez entrecomillada con el
# tipo de objeto
number <- 2L
typeof(number)

# Conocer el tipo de columnas de una tabla 
str(gastos)

# Conocer la longitud de un objeto tipo vector o lista 
length(v_vector)
length(x)

### Usando R como calculadora
# Suma
1 + 13
# Resta 
16 - 7
# Multiplicación 
14.0056 * 3.25
# División
16 / 2
# Potencia
7 ^ 3 

11 / 4 # Division
11 %/% 4 # Cociente # Cociente parte entera
11 %% 4 # Resto (módulo)

# ------------------------------------
# Funciones un poco mas avanzadas
# -------------------------------------

# celing(a) # Menor entero mayor que a
# floor(a) # Mayor entero menos que a
# round(a, d) # Redondeo a con d decimales 
# signif(a, d) # Presenta a con d digitos en notación científica 
# trunc(a) # Elimina los decimales de (a) hacia 0

# El redondeo puede ser hacia el menor entero superior con ceiling(), hacia el mayor entero inferior con floor(),
# ir eliminando decimales parcialmente con round(), o totalmente con trunc(). También se puede
# dejar un número de cifras significativas con signif(). La que más utilizaremos, sin ninguna duda, será la de redondeo.

# Ejemplo de aplicabilidad de esto 
# Dato un resultado x = 7.6459871, se pide
# a) Redondear x a tres decimales
# b) Calcular el menor entero superior a x
# c) Calcular el mayuor entero menor que x
# d) Eliminar todos los decimales de x 
# e) Presentar x con dos cifras significativas 

x <- 3.45787
round(x, 3)
ceiling(x)
floor(x)
trunc(x)
signif(x, 2)

# En un ejercicio de cálculo del tamaño muestral se obtiene n = 127.13, ¿cuántos sujetos se necesitan?
# Como el número de sujetos no puede tener decimales, el resultado debe redondearse menor entero superior a n, 
# por tanto, utilizando la función ceiling. 

floor(122.3)

# Matemáticas generales
# Ejemplo, para x = 7.6459871, calcule.
# a) ln de x
# b) raiz cuadrada de x 
# c) exponencia de x
# d) valor absoluto de x

# Solución:
log(x)
sqrt(x)
exp(x)
abs(x)
abs(-3)

# Fin del codigo
# Fabio Alexander Castro - Llanos 

