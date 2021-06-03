# Define the header (on every page)
header <- shinydashboard::dashboardHeader(
  
  # Use logo in the title
  title = tags$img(src = "logo.png"), #"Open Data Portal Dashboard"

  tags$li(class = "dropdown",
          tags$a(HTML(paste("Refreshed at: ", "0"))))
  
)

# Define the sidebar (on every page)
sidebar <- shinydashboard::dashboardSidebar(
  
  shinydashboard::sidebarMenu(
    
    id = "side_bar",
    
    # Tab List
    shinydashboard::menuItem(
      text = "Introduction", 
      tabName = "introduction"
    ),
    shinydashboard::menuItem(
      text = "Region", 
      tabName = "region"
    )
  )
)

# Define the main body of the dashboard
body <- shinydashboard::dashboardBody(
  
  # Load in styling file
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),
  
  # Display the security classification at the top of each page
  shiny::titlePanel(
    shiny::h1(
      id = "title-panel", 
      "Open Data Portal Dashboard"
    )
  ),
  
  # Iterate over each tab and fill
  shinydashboard::tabItems(
    
    # Include the markdown for introduction tab
    introduction_ui(),
    region_ui()
  )
)

# Define the UI
ui <- shinydashboard::dashboardPage(
  header,
  sidebar,
  body#,
  #styling
)