server <- function(input, output) {
  
  # Parse the response
  resource_response <- jsonlite::fromJSON(paste0(
    base_endpoint, 
    package_show_id, 
    dataset_id
  ))
  
  # Extract the resources
  resource_list <- resource_response$result$resources$name
  
  # Add each of the tabs   
  ccg_server(resource_list = resource_list)

}