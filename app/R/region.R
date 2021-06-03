region_ui <- function(id = "region") {
  
  ns <- shiny::NS(id)
  
  shinydashboard::tabItem(
    tabName = "region",
    shiny::fluidRow(
      id = "region_plot",
      shinydashboard::box(
        width = 12,
        solidHeader = TRUE,
        highcharter::highchartOutput(
          outputId = ns("plot"), 
          width = "100%",
          height = "700px"
        )
      )
    )
  )
}

region_server <- function(id = "region") {
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {
      
      # Construct the SQL query
      sql_query <- function(resource_id) {
        paste0("
               SELECT 
                 year_month,
                 regional_office_name, 
                 SUM(items) AS total_items,
                 SUM(nic) AS total_nic
               
               FROM ", 
                resource_id, " 
               
               GROUP BY
                 year_month,
                 regional_office_name
               ")
      }
      
      # Create the URLs for the API calls
      urls <- lapply(
        X = resource_id_list,
        FUN = function(x) 
          paste0(
            base_endpoint,
            access_datastore_search_sql, 
            URLencode(sql_query(x))
          )
      )
      
      # Use Async to get the results
      dd <- crul::Async$new(urls = urls)
      res <- dd$get()
      
      # Check that everything is a success
      all(vapply(res, function(z) z$success(), logical(1)))
      
      # Parse the output into a list of dataframes
      df_list <- lapply(
        X = res, 
        FUN = function(x) {
          
          # Parse the response
          record_response <- x$parse("UTF-8")
          
          # Extract the records
          record_df <- jsonlite::fromJSON(record_response)$result$result$records
        }
      )
      
      # Concatenate the results - ignoring blank outputs for early months and using
      # data.table for speed
      df <- data.table::rbindlist(
        l = Filter(function(x) inherits(x, "data.frame"), df_list)
      )
      
      # Convert year_month to date
      df <- df %>%
        dplyr::mutate(
          year_month = zoo::as.yearmon(paste0(substr(year_month, 1, 4),
                                              "-",
                                              substr(year_month, 5, 6))))
      
      output$plot <- highcharter::renderHighchart({
        
        # Produce the lineplot
        highcharter::highchart() %>% 
          highcharter::hc_add_series(data = df, 
                                     "line", 
                                     highcharter::hcaes(x = year_month, 
                                                        y = total_items,
                                                        color = regional_office_name,
                                                        group = regional_office_name))
      })
      
    }
  )
}