ccg_ui <- function(id = "ccg") {
  
  # Create a namespace function
  ns <- shiny::NS(id)
  
  # Create the CCG tab
  shinydashboard::tabItem(
    
    # Name of the tab
    tabName = "ccg",
    
    # Design of the tab
    shiny::fluidPage(
      
      # First row contains a CCG dropdown selector
      shiny::fluidRow(
        shiny::column(
          width = 12,
          shiny::uiOutput(ns("latest_ccgs"))
        )
      ),
      
      # Second row contains a datatable of items for the selected CCG
      shiny::fluidRow(
        shiny::column(
          width = 12,
          shiny::textOutput(ns("tst"))
        )
      )
    )
  )
}

ccg_server <- function(id = "ccg", resource_list) {
  
  # Create a namespace function
  ns <- shiny::NS(id)
  
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {
     
      # Pull the latest CCGs into a dataframe
      latest_ccg_df <- shiny::reactive({
        create_df_from_query(
          endpoint = paste0(base_endpoint, datastore_search_sql),
          resource_list = tail(resource_list, 1), # Latest month
          query_function = function(x) {
            
            paste0(
              "
              SELECT DISTINCT 
                pco_name,
                pco_code
  
              FROM `",
                x, "` 
              
              WHERE
                RIGHT(pco_name, 3) = 'CCG' 
              
              ORDER BY
                pco_name
              "
            )
            
          }
        )
      })
      
      # Convert the latest CCGs into a named lised
      latest_ccg_list <- shiny::reactive({
        latest_ccg_df() %>%
          dplyr::select(pco_name, pco_code) %>%
          tibble::deframe()
      })
      
      # Add a named list of the latest CCGs to the output
      output$latest_ccgs <- shiny::renderUI({
        
        shiny::selectInput(
          inputId = "tst",
          label = "Select the CCG",
          choices = latest_ccg_list()
        )
      })
      
      # Try to process the selected CCG
      tst <- shiny::reactive({input$tst})
      output$tst <- shiny::renderText({paste("You selected:", tst())})

    }
  )
}