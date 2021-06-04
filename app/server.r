server <- function(input, output) {
  
  # Load data from ODP API
  odp_df <- readRDS("data/total_items_nic.Rds")
  
  # Load boundary data
  ccg_boundary <- create_boundary(
    url = "https://opendata.arcgis.com/api/v3/datasets/d6acd30ad71f4e14b4de808e58d9bc4c_0/downloads/data?format=geojson&spatialRefId=4326", 
    filter_col = "CCG21CD"
  )
  stp_boundary <- create_boundary(
    url = "https://opendata.arcgis.com/api/v3/datasets/dfbbf1aec521476eb7887d7ee28338e2_0/downloads/data?format=geojson&spatialRefId=4326",
    filter_col = "STP21CD"
  )
  region_boundary <- create_boundary(
    url = "https://opendata.arcgis.com/api/v3/datasets/5e33fd1436114a19b335ed07076a4c5b_0/downloads/data?format=geojson&spatialRefId=4326",
    filter_col = "nhser20cd"
  )
  
  # Add each of the tabs 
  items_server(
    odp_df = odp_df, 
    region_boundary = region_boundary
  )

}