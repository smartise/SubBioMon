library(leaflet)
library(htmlwidgets)
library(readxl)

this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

loca <- read_excel("Localisation.xlsx")

map <- leaflet(data = loca) %>%
  setView(lat = 54.5260, lng = 15.2551, zoom = 4)%>%
  addMarkers(~lng, ~lat, popup = ~name)%>%
  addProviderTiles("OpenStreetMap",
                   group = "OpenStreetMap") 

map
save(map, file = "map.Rdata")

