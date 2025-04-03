library(sf)
library(tbeptools)
library(here)

# get TB wbids --------------------------------------------------------------------------------

tmp <- st_read('https://ca.dep.state.fl.us/arcgis/rest/services/OpenData/WBIDS/MapServer/0/query?outFields=*&where=1%3D1&f=geojson')

tmp <- st_make_valid(tmp)
tbwbid <- tmp[tbshed, ]

save(tbwbid, file = here::here('site/data', 'tbwbid.RData'))
