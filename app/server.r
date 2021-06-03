server <- function(input, output) {
  
  # Find what resources are available
  resouce_response <- jsonlite::fromJSON(
    txt = paste0(base_endpoint, access_package_show_id, dataset_id)
  )
  
  # Extract the resources
  resource_id_list <- resouce_response$result$resources$name
  
  #introduction_server()
  region_server()
  
}