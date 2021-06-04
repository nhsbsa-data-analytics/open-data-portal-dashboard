items_ui <- function(id = "items") {
  
  ns <- shiny::NS(id)
  
  shinydashboard::tabItem(
   
    "items",
    shiny::fluidRow(
      shinydashboard::tabBox(
        width = 12,
        side = "left",
        id = "items_tab_panel",
        selected = "Region",
        
        # TabPanel One -------------------------------------------------------
        shiny::tabPanel(
          title = "Region",
          shiny::fluidRow(
            column(
              width = 8,
              box(
                width = 12,
                solidHeader = T,
                title = "Regions Items Table",
                reactable::reactableOutput(ns("region_table"), height = "300px")
              ),
              box(
                width = 12,
                solidHeader = T,
                title = "Regions Items Line",
                highcharter::highchartOutput(ns("region_line"), height = "300px")
              )
            ),
            column(
              width = 4,
              box(
                width = 12,
                solidHeader = T,
                title = "Regions Items Map",
                highcharter::highchartOutput(ns("region_map"), height = "600px")
              )
            )
          )
        )
      )
    )
  )
}

items_server <- function(id = "items", odp_df, region_boundary) {
  shiny::moduleServer(
    id = id,
    module = function(input, output, session) {
      
      # Create region data
      region_table_reactive <- shiny::reactive({
        odp_df %>%
          group_sum("items", region_code, region_name)
      })
      
      # Add the region table to the output
      output$region_table <- reactable::renderReactable({
        create_reactable(region_table_reactive(), "items")
      })
      
      # Create the click for the table
      region_click <- shiny::reactive(
        reactable::getReactableState(
          outputId = "region_table", 
          name = "selected")
      )
      
      # GET REGION CODE
      region_code = shiny::reactive({
        region_table_reactive() %>% 
          dplyr::filter(row_number() %in% region_click()) %>% 
          dplyr::select(region_code) %>% 
          dplyr::pull()
      })
      
      # LINE CHART DATA
      region_line_reactive = shiny::reactive({
        odp_df %>%
          group_sum("items", year_month, region_code, region_name) %>% 
          dplyr::filter(region_code %in% region_code())
      })
      
      # LINE CHART
      observeEvent(
        eventExpr = region_click(),
        handlerExpr = {
          output$region_line = highcharter::renderHighchart({
            create_hc_line_plot(
              df = region_line_reactive(), 
              y_axis_text = "Date",
              filter_col = "region_name",
              value_col = "items"
            )
          })
      })
      
      # PLOT MAP
      output$region_map = highcharter::renderHighchart({
        create_hc_map_plot(
          df = odp_df %>%
            group_sum("items", year_month, region_code, region_name), 
          boundary = region_boundary, 
          filter_col = "region_code",
          value_col = "items"
        )
      })
    }
  )
}