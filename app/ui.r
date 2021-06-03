# UI ---------------------------------------------------------------------------
header = dashboardHeader(
  title = "ODP - Items & NIC"
)

# Define the sidebar (on every page) -------------------------------------------
sidebar = dashboardSidebar(
  width = 200,
  sidebarMenu(
    # Static Sidebar
    #style = "position: fixed; overflow: visible;",
    
    # Tab List
    menuItem(
      text = strong("Introduction"),
      tabName = "introduction"
    ),
    menuItem(
      text = strong("Items"),
      tabName = "items_tab"
    ),
    menuItem(
      text = strong("NIC"),
      tabName = "nic_tab"
    )
  )
)


# Define the main body of the dashboard ----------------------------------------
body = dashboardBody(
  
  # Main theme
  shinyDashboardThemes(
    theme = "grey_light"
  ),
  
  # Iterate over each tab and fill
  tabItems(
    
    # Tab Two ------------------------------------------------------------------
    tabItem(
      "items_tab",
      fluidRow(
        tabBox(
          width = 12,
          side = "left",
          id = "items_tab_panel",
          selected = "Region",
          
          # TabPanel One -------------------------------------------------------
          tabPanel(
            title = "Region",
            fluidRow(
              column(
                width = 8,
                box(
                  width = 12,
                  solidHeader = T,
                  title = "Regions Items Table",
                  reactableOutput("items_region_table", height = "300px")
                ),
                box(
                  width = 12,
                  solidHeader = T,
                  title = "Regions Items Line",
                  highchartOutput("items_region_line", height = "300px")
                )
              ),
              column(
                width = 4,
                box(
                  width = 12,
                  solidHeader = T,
                  title = "Regions Items Map",
                  highchartOutput("items_region_map", height = "600px")
                )
              )
            )
          ),
          
          # TabPanelTwo --------------------------------------------------------
          tabPanel(
            title = "STP",
            fluidRow(
              column(
                width = 8,
                box(
                  width = 12,
                  solidHeader = T,
                  title = "STP Items Table",
                  reactableOutput("items_stp_table", height = "300px")
                ),
                box(
                  width = 12,
                  solidHeader = T,
                  title = "STP Items Line",
                  highchartOutput("items_stp_line", height = "300px")
                )
              ),
              column(
                width = 4,
                box(
                  width = 12,
                  solidHeader = T,
                  title = "STP Items Map",
                  highchartOutput("items_stp_map", height = "600px")
                )
              )
            )
          ),
          
          # TabPanel Three -----------------------------------------------------
          tabPanel(
            title = "CCG",
            fluidRow(
              column(
                width = 8,
                box(
                  width = 12,
                  solidHeader = T,
                  title = "CCG Items Table",
                  reactableOutput("items_ccg_table", height = "300px")
                ),
                box(
                  width = 12,
                  solidHeader = T,
                  title = "CCG Items Line",
                  highchartOutput("items_ccg_line", height = "300px")
                )
              ),
              column(
                width = 4,
                box(
                  width = 12,
                  solidHeader = T,
                  title = "CCG Items Map",
                  highchartOutput("items_ccg_map", height = "600px")
                )
              )
            )
          )

          #---------------------------------------------------------------------
        )
      )
    )
  )
)
          
# Define the UI ----------------------------------------------------------------
ui = dashboardPage(
  header, 
  sidebar, 
  body
)

#-------------------------------------------------------------------------------
