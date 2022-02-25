create_df_from_query <- function(endpoint, resource_list, query_function) {
  
  # Create the URLs for the API calls
  urls <- lapply(
    X = resource_list,
    FUN = function(x) 
      paste0(
        endpoint,
        "resource_id=",
        x,
        "&sql=",
        utils::URLencode(query_function(x)) # Encode spaces in the url
      )
  )
  
  # Use Async to get the results
  dd <- crul::Async$new(urls = urls)
  res <- dd$get()
  
  # Parse the output into a list of dataframes
  df_list <- lapply(
    X = res, 
    FUN = function(z) {
      
      # Parse the response
      record_response <- z$parse("UTF-8")
      
      # Extract the records
      record_df <- jsonlite::fromJSON(record_response)$result$result$records
    }
  )
  
  # Concatenate the results (ignoring blank outputs for early months)
  df <-  do.call(
    what = "rbind", 
    args = Filter(function(x) inherits(x, "data.frame"), df_list)
  )

  return(df)
  
}
