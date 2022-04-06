#06/04/2022
#Distancia entre estaciones

# Cargar paquetes ---------------------------------------------------------
pacman::p_load(raster, rgeos, rgdal,readxl)

# Ruta de trabajo ---------------------------------------------------------
setwd("D:/GITHUB/Dist. Estaciones")

#Leer el archivo excel
est_excel <- read_excel("Estaciones.xlsx") 

#Crear archivo espacial
est_shp <- SpatialPointsDataFrame(coords=est_excel[,2:3], data=est_excel)

#Dando un sistema de coordenadas
proj4string(est_shp) <- CRS("EPSG:4326")

#Reproyectando a zona UTM 18S
est_shp_utm <- spTransform(est_shp, CRS("EPSG:32718"))

#Extrayendo las coordenadas
coor_esta <- data.frame(est_shp_utm@coords/1000) #Dividimos entre 1000 para pasarlo a  km

#Extraccion de las filas que contiene los datos
est_sc <-coor_esta[1:15,] 

#Calculando la distancia
dis_esta <- data.frame(as.matrix(dist(est_sc)))

#Nombres de las estaciones
names(dis_esta) <- est_shp$Estacion[1:15]
row.names(dis_esta) <- est_shp$Estacion[1:15]

#Guardar archivo con distancias entre estaciones
write.csv(dis_esta, "Distancia de estaciones.csv")

# Ploteo ------------------------------------------------------------------
plot(est_sc, pch=20, cex=2, col="blue", main="Distancia entre estaciones (km)")
text(est_sc, names(dis_esta), cex=0.6, adj = 1, pos=1)
