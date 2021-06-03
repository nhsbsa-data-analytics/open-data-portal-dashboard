summary_ui <- function() {
  tabItem(
    "summary",
    fluidRow(

      
      
    ),
    fluidRow(
      id = "summary_plot",
      box(
        width = 9,
        solidHeader = TRUE,
        title = get_text("plot", id),
        highchartOutput(ns("plot"), width = "100%", height = "400px"),
        # Dont read the caveats in from app_text as there is special formatting for some of it
        p("CAVEAT HERE"))
    )
  )
}

summary_server <- function(id, metric_tables) {
  moduleServer(
    id,
    function(input, output, session) {
      daily_or_cumulative <- radio_group_server("daily_or_cumulative")
      date_range <- date_range_server("date_input")
      
      output$plot = renderHighchart({
        plot_functions[["total_cases_and_contacts"]](
          metric_tables = metric_tables(),
          daily_or_cumulative = daily_or_cumulative(),
          start_date = date_range$start,
          end_date = date_range$end
        )
      })
      
      summary_dates <- graph_zoom_server("plot", date_range)
      
      output$summary_table = renderTable({
        summary_table_functions[["total_cases_and_contacts"]](
          metric_tables = metric_tables(),
          date_range = summary_dates
        )
      },
      bordered = TRUE,
      hover = TRUE,
      spacing = 'm',
      align = 'lr',
      width = '100%'
      )
      
      output$summary_date_range = renderText({
        paste("Summary table is displaying data between", summary_dates$start, "and", summary_dates$end)
      })
    }
  )
}