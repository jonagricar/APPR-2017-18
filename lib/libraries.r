library(knitr)
library(dplyr)
library(readr)
library(rvest)
library(gsubfn)
library(ggplot2)
library(reshape2)
library(shiny)
library(devtools)
library(tidyr)
library(digest)
library(rgeos)
library(maptools)
library(rmarkdown)
library(DT)
library(extrafont)



# Uvozimo funkcije za pobiranje in uvoz zemljevida.
source("lib/uvozi.zemljevid.r", encoding = "UTF-8")
