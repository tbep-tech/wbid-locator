library(sf)
library(tbeptools)
library(here)

# get TB wbids --------------------------------------------------------------------------------

tmp <- st_read('https://ca.dep.state.fl.us/arcgis/rest/services/OpenData/WBIDS/MapServer/0/query?outFields=*&where=1%3D1&f=geojson')

tmp <- st_make_valid(tmp)
tbwbid <- tmp[tbshed, ]

save(tbwbid, file = here::here('app/data', 'tbwbid.RData'))

# make WBID and bay segment table -------------------------------------------------------------

load(file = here('app/data', 'tbwbid.RData'))
data('tbsegshed', package = 'tbeptools')

tmp <- st_join(tbwbid, tbsegshed, join = st_nearest_feature)

# get intersection and select largest area
tbwbidseg <- st_intersection(tbwbid, tbsegshed) |>
  mutate(
    area = st_area(geometry)
  ) |>
  group_by(WBID) %>%
  slice_max(order_by = area, n = 1) %>%
  ungroup() %>%
  select(WBID, long_name, bay_segment) |>
  st_set_geometry(NULL)

save(tbwbidseg, file = here('app/data', 'tbwbidseg.RData'))

# # verify
# library(mapview)
# tmp <- tbwbid |>
#   left_join(tbwbidseg, by = 'WBID')
# mapview(tmp, zcol = 'bay_segment') + mapview(tbsegshed, alpha.regions = 0, color = 'red')
