library(shiny)
library(sf)
library(bslib)

data(tbwbid)

# Get the overall bounding box
get_bbox <- function(polygons) {
  bbox <- st_bbox(polygons)
  return(bbox)
}

# Find which polygon contains the point
find_containing_polygon <- function(lat, lon, polygons, bbox) {

  # Create a point from lat and lon
  point <- st_point(c(lon, lat))
  point_sf <- st_sfc(point, crs = 4326)

  # intersect
  int <- st_intersection(polygons, point_sf)

  if(nrow(int) == 0)
    return("Point is not within any defined region.")
  else
    return(paste("Point is within WBID", int$WBID))

}

# Initialize bounding box
bbox <- get_bbox(tbwbid)

ui <- page_sidebar(
  title = "Tampa Bay WBID Finder",
  sidebar = sidebar(
    title = "Coordinates Input",
    numericInput("lat", "Latitude (decimal degrees):",
                 value = 28, min = bbox[['ymin']], max = bbox[['ymax']], step = 0.1),
    numericInput("lon", "Longitude (decimal degrees):",
                 value = -82, min = bbox[['xmin']], max = bbox[['xmax']], step = 0.1),
    actionButton("find", "Find WBID", class = "btn-primary"),
    hr(),
    helpText("Enter coordinates and click 'Find WBID' to determine which WBID contains the point.")
  ),

  card(
    card_header("Result"),
    card_body(
      textOutput("result")
    )
  ),

  card(
    card_header("Map Boundaries"),
    card_body(
      HTML("The map includes all WBIDs in Tampa Bay and its watershed:"),
      tags$ul(
        tags$li(paste("Valid longitude range:", bbox["xmin"], "to", bbox["xmax"])),
        tags$li(paste("Valid latitude range:", bbox["ymin"], "to", bbox["ymax"]))
      ),
      HTML("Some combinations may be outside of the range.")
    )
  )
)

server <- function(input, output, session) {
  result <- eventReactive(input$find, {
    find_containing_polygon(input$lat, input$lon, tbwbid, bbox)
  })

  output$result <- renderText({result()})

}

shinyApp(ui, server)
