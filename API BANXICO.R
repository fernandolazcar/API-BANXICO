---
title: "API BANXICO R"
author: "Fernando Lazcano"
date: "25/2/2024"
output: 
  bookdown::html_document2:
    toc: true
    toc_float: true
    number_sections: false
---

# I N T R O D U C C I Ó N     

La api de BANXICO llamada "siebanxicor" no es nada mas que el sistema de informacion economica, publicada en 2018 y propiedad de DGIE - Banco de México, con la cual podremos acceder de forma rapida y a tiempo real a nuestros indicadores de interes. 

LIBRERIAS 
```{r, message=FALSE, warning=FALSE}
library(siebanxicor) # API DE BANXICO
library(tidyverse)   # MANIPULACION DE DATOS
library(lubridate)   # FECHA Y HORA
library(ggplot2)     # GRAFICOS
library(plotly)      # GRAFICO DINAMICO 
library(bookdown)    # INDICE FLOTANTE 
```
### MANIPULACION DE DATOS 

Ingresamos nuestro token que nos servira para poder accesar a los indicadores 

```{r}
setToken('dcaaadd6d87d5dbe4b8a76e47df134d861cee3e0c6df85283a32643572e66bb5')
```

Identificamos la serie economica de proporcionada  por el catalogo de indicadores.

donde :

SG29 = Gastos Presupuestales del Sector Público Clasificación Económica Gasto presupuestario Gasto programable ; de periodicidad mensial en millones de pesos 

SG9 = Ingresos y Gastos Presupuestales del Gobierno Federal Medición por Ingreso-Gasto, Flujos de Caja Ingreso total ; de periodicidad mensial en millones de pesos 


```{r}
idSeries <- c("SG29", "SG9")
```

para poder ver la informaicon de nuestras series de tiempo podemos acceder a los metadatos que daran mas detalles sobre el indice.

```{r}

metadata <- getSeriesMetadata(idSeries)


metadata

```


Usamos la fecha de hoy y un punto en el pasado para analizar nuestros resultados 

```{r}
hoy <- Sys.Date()


series <- getSeriesData(idSeries, '2000-01-01', hoy)
```


hacemos nuestro data frame  y ocupamos na.omit para saltarnos los resultados que no tinen datos y asi poder graficar

```{r}
df = as.data.frame(series)

df <- na.omit(df)

head(df)
```

limpieza del data frame, primero veremos que en la serie tenemos una columna con los mismos valores que es la de la fecha (SG29.date y SG9.date)

```{r}
#eliminamos la columna 3 porque era la que nos estorbaba 
df <- df[ ,-c(3)]
str(df) # vemos propiedades 
head(df)

```
### Grafico 

Hacemos nuestro grafico para poder ver el comportamiento de nuestras series de tiempo 


```{r}
g = ggplot(df, aes(x = SG29.date)) +
     geom_line(aes(y = SG29.value, color = "gasto")) +
     geom_line(aes(y = SG9.value, color = "ingreso")) +
     labs(x = "Fecha", y = "Millones de Pesos", color =   "Series") +
     ggtitle("Ingreso vs Gasto 2000-2023") +
     theme_minimal() +
     scale_y_continuous(labels = scales::comma) # Esto ajusta     el formato de los números en el eje y


#grafico dinamico 

ggplotly(g)

```


Elaborado por FERNANDO LAZCANO CÁRDENAS 


fuentes : 


https://cran.r-project.org/web/packages/siebanxicor/siebanxicor.pdf

https://rpubs.com/ecodiegoale/api_banxico
