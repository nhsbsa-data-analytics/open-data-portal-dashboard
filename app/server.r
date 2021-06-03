# DEFINE SERVER ----------------------------------------------------------------
server <- function(input, output) {
  
  # REGION ITEMS DATA ----------------------------------------------------------
  
  items_region_table_reactive = reactive({
    table_group_by(data, "region_code", "region_name", "items")
  })
  
  # REGION ITEMS TABLE
  
  output$items_region_table = renderReactable({
    create_reactable(items_region_table_reactive(), "items")
  })
  
  # REGION TABLE CLICK
  
  items_region_click = reactive(getReactableState("items_region_table", "selected")) # NOTE: 'selected' is set parameter option
  
  # GET REGION CODE
  
  items_region_code = reactive({
    items_region_table_reactive() %>% 
      filter(row_number() %in% items_region_click()) %>% 
      select(region_code) %>% 
      pull()
  })
  
  # LINE CHART DATA
  
  items_region_line_reactive = reactive({
    year_month_group_by(data, "region_code", "region_name", "items") %>% 
      filter(region_code %in% items_region_code())
  })
  
  # LINE CHART
  
  observeEvent(items_region_click(),{
    output$items_region_line = renderHighchart({
      plot_line(items_region_line_reactive(), "items", "region_name")
    })
  })
  
  # ITEMS REGION MAP DATA
  
  items_region_map_reactive = reactive({
    year_month_group_by(data, "region_code", "region_name", "items")
  })
  
  # ITEMS REGION MAP MAX_VAL
  
  max_items_region = reactive({
    get_max_val(items_region_map_reactive(), "region_code", "items")
  })
  
  # MAP ANIMATION FUNCTION
  
  items_region_map_list = reactive({
    get_map_data(items_region_map_reactive(), "region_code", "items")
  })
  
  # PLOT MAP
  
  output$items_region_map = renderHighchart({
    plot_map(items_region_map_list(), region_boundary, max_items_region())
  })
  
  
  
  # STP ITEMS DATA -------------------------------------------------------------
  
  items_stp_table_reactive = reactive({
    table_group_by(data, "stp_code", "stp_name", "items")
  })
  
  # REGION ITEMS TABLE
  
  output$items_stp_table = renderReactable({
    create_reactable(items_stp_table_reactive(), "items")
  })
  
  # REGION TABLE CLICK
  
  items_stp_click = reactive(getReactableState("items_stp_table", "selected")) # NOTE: 'selected' is set parameter option
  
  # GET REGION CODE
  
  items_stp_code = reactive({
    items_stp_table_reactive() %>% 
      filter(row_number() %in% items_stp_click()) %>% 
      select(stp_code) %>% 
      pull()
  })
  
  # LINE CHART DATA
  
  items_stp_line_reactive = reactive({
    year_month_group_by(data, "stp_code", "stp_name", "items") %>% 
      filter(stp_code %in% items_stp_code())
  })
  
  # LINE CHART
  
  observeEvent(items_stp_click(),{
    output$items_stp_line = renderHighchart({
      plot_line(items_stp_line_reactive(), "items", "stp_name")
    })
  })
  
  # ITEMS REGION MAP DATA
  
  items_stp_map_reactive = reactive({
    year_month_group_by(data, "stp_code", "stp_name", "items")
  })
  
  # ITEMS REGION MAP MAX_VAL
  
  max_items_stp = reactive({
    get_max_val(items_stp_map_reactive(), "stp_code", "items")
  })
  
  # MAP ANIMATION FUNCTION
  
  items_stp_map_list = reactive({
    get_map_data(items_stp_map_reactive(), "stp_code", "items")
  })
  
  # PLOT MAP
  
  output$items_stp_map = renderHighchart({
    plot_map(items_stp_map_list(), stp_boundary, max_items_stp())
  })
  
  
  
  # CCG ITEMS DATA -------------------------------------------------------------
  
  items_ccg_table_reactive = reactive({
    table_group_by(data, "ccg_code", "ccg_name", "items")
  })
  
  # REGION ITEMS TABLE
  
  output$items_ccg_table = renderReactable({
    create_reactable(items_ccg_table_reactive(), "items")
  })
  
  # REGION TABLE CLICK
  
  items_ccg_click = reactive(getReactableState("items_ccg_table", "selected")) # NOTE: 'selected' is set parameter option
  
  # GET REGION CODE
  
  items_ccg_code = reactive({
    items_ccg_table_reactive() %>% 
      filter(row_number() %in% items_ccg_click()) %>% 
      select(ccg_code) %>% 
      pull()
  })
  
  # LINE CHART DATA
  
  items_ccg_line_reactive = reactive({
    year_month_group_by(data, "ccg_code", "ccg_name", "items") %>% 
      filter(ccg_code %in% items_ccg_code())
  })
  
  # LINE CHART
  
  observeEvent(items_ccg_click(),{
    output$items_ccg_line = renderHighchart({
      plot_line(items_ccg_line_reactive(), "items", "ccg_name")
    })
  })
  
  # ITEMS REGION MAP DATA
  
  items_ccg_map_reactive = reactive({
    year_month_group_by(data, "ccg_code", "ccg_name", "items")
  })
  
  # ITEMS REGION MAP MAX_VAL
  
  max_items_ccg = reactive({
    get_max_val(items_ccg_map_reactive(), "ccg_code", "items")
  })
  
  # MAP ANIMATION FUNCTION
  
  items_ccg_map_list = reactive({
    get_map_data(items_ccg_map_reactive(), "ccg_code", "items")
  })
  
  # PLOT MAP
  
  output$items_ccg_map = renderHighchart({
    plot_map(items_ccg_map_list(), ccg_boundary, max_items_ccg())
  })
  
  #-----------------------------------------------------------------------------

}


#-------------------------------------------------------------------------------

# a = year_month_group_by(data, "region_code", "region_name", "items")
# 
# b = get_max_val(a, "region_code", "items")
# 
# c = get_map_data(a, "region_code", "items")
# 
# plot_map(c, region_boundary, b)
# 
# # PLOT MAP
# 
# output$items_region_map = renderHighchart({
#   plot_map(items_region_map_list(), region_boundary, max_items_region())
# })


# 
# c = year_month_group_by(data, "ccg_code", "ccg_name", "items")
# 
# d = c %>% 
#   rename(value = items) %>% 
#   arrange(ccg_code, year_month) %>% 
#   group_by(ccg_code) %>% 
#   mutate(value = cumsum(value)) %>% 
#   ungroup() %>% 
#   group_by(ccg_code) %>% 
#   mutate(value = as.numeric(value)) %>% 
#   do(item = list(
#     ccg_code = first(.$ccg_code),
#     sequence = .$value,
#     value = first(.$value)) %>% 
#       rename_at("ccg_code", ~"xyz")
#     ) %>% 
#   .$item
# 
# highchart(type = "map") %>% 
#   hc_add_series(
#     data = d,
#     name = "Items per Region Since 2014",
#     mapData = ccg_boundary_edit,
#     joinBy = "ccg_code",
#     borderWidth = 0.2,
#     borderColor = "black"
#   ) %>% 
#   hc_colorAxis(min = 0, max = max_val) %>% 
#   hc_legend(
#     layout = "horizontal",
#     reversed = TRUE,
#     floating = TRUE,
#     align = "right"
#   ) %>% 
#   hc_motion(
#     enabled = TRUE,
#     axisLabel = "year",
#     labels = sort(unique(data$year_month)),
#     series = 0,
#     updateIterval = 30,
#     magnet = list(
#       round = "floor",
#       step = 0.18
#     )
#   ) %>% 
#   hc_chart(marginBottom  = 60)
# 
# 
# 
# 
# highchart(type = "map") %>% 
#   hc_add_series(
#     data = d,
#     name = "Items per Region Since 2014",
#     mapData = region_boundary,
#     joinBy = "nhser20cd",
#     borderWidth = 0.01
#   )


# colors <- c("red", "blue", "green" , "yellow")
# 
# hcmap("countries/us/us-all", data = data_fake, value = "value",
#       joinBy = c("hc-a2", "code"), name = "Fake data",
#       dataLabels = list(enabled = TRUE, format = '{point.name}'),
#       borderColor = "#FAFAFA", borderWidth = 0.1,
#       tooltip = list(valueDecimals = 2, valuePrefix = "$", valueSuffix = 
#                        "USD"))%>%
#   hc_colorAxis(minColor = "blue", maxColor = "red", 
#                stops = color_stops(n=length(colors), colors = colors))

# a = table_group_by(data, "region_code", "region_name", "items") %>% 
#   rename(
#     nhser20cd = region_code,
#     value = items
#   ) %>% 
#   mutate(color = colorize(1:7, c("lightblue", "red"))[cut(a$value, 7)])
# 
# highchart(type = "map") %>% 
#   hc_add_series(
#     data = a,
#     mapData = region_boundary,
#     joinBy = "nhser20cd",
#     borderWidth = 3
#   )
