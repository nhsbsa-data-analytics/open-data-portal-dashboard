
#SHINY APPP FUNCTIONS ----------------------------------------------------------

# SIMPLEE GROUP BY TO CREATE TAABLE

table_group_by = function(data, area_code, area_name, items_or_nic){
  
  if(items_or_nic == "items"){
    data = data %>% 
      group_by_at(c(area_code, area_name)) %>% 
      summarise(items = sum(items)) %>% 
      ungroup()
  }else{
    data = data %>% 
      group_by_at(c(area_code, area_name)) %>% 
      summarise(nic = sum(nic)) %>% 
      ungroup()
  }
  return(data)
} 

# GROUP BY WITH YEAR_MONTH INCLUDED

year_month_group_by = function(data, area_code, area_name, items_or_nic){
  
  if(items_or_nic == "items"){
    data = data %>% 
      group_by_at(c("year_month", area_code, area_name)) %>% 
      summarise(items = sum(items)) %>% 
      ungroup() %>% 
      mutate(year_month = as.factor(year_month))
  }else{
    data = data %>% 
      group_by_at(c("year_month", area_code, area_name)) %>% 
      summarise(nic = sum(nic)) %>% 
      ungroup() %>% 
      mutate(year_month = as.factor(year_month))
  }
  return(data)
} 

# CREATE REACTABLE FUNCCTION 

create_reactable = function(data, items_or_nic){
  
  if(items_or_nic == "items"){
    output = reactable(
      data,
      filterable = TRUE,
      highlight = TRUE,
      compact = TRUE,
      showSortable = TRUE,
      bordered = TRUE,
      pagination = FALSE,
      defaultSelected = 1,
      selection = "multiple",
      onClick = "select",
      columns = list(
        items = colDef(name = "Items", format = colFormat(separators = T, digits = 0))
      )
    )
  }else{
    output = reactable(
      data,
      filterable = TRUE,
      highlight = TRUE,
      compact = TRUE,
      showSortable = TRUE,
      bordered = TRUE,
      pagination = FALSE,
      defaultSelected = 1,
      selection = "single",
      onClick = "select",
      columns = list(
        nic = colDef(name = "NIC", format = colFormat(separators = T, digits = 0))
      )
    )
  }
  return(output)
}

# LOAD BOUNDARY DATA FUNCTION

load_edit_bounary = function(url, old_code){
  
  data = read_sf(url) %>% 
    st_as_sf() %>% 
    st_transform(27700) %>% 
    rename_at(old_code, ~"area_code") %>%
    select(area_code) %>% 
    sf_geojson() %>% 
    fromJSON(simplifyVector = F)
  return(data)
}

# GET MAP CUMULATIVE MAX_VAL

get_max_val = function(data, area_code, items_or_nic){
  
  if(items_or_nic == "items"){
    output = data %>% 
      arrange_at(c(area_code, "year_month")) %>% 
      group_by_at(area_code) %>% 
      mutate(value = cumsum(items)) %>% 
      ungroup() %>% 
      summarise(max(value)) %>% 
      pull()
  }else{
    output = data %>% 
      arrange_at(c(area_code, "year_month")) %>% 
      group_by_at(area_code) %>% 
      mutate(value = cumsum(nic)) %>% 
      ungroup() %>% 
      summarise(max(value)) %>% 
      pull()
  }
  return(output)
}

# GET MAP DATA LIST

get_map_data = function(data, old_code, items_or_nic){
  
  if(items_or_nic == "items"){
    data = data %>% 
      rename(value = items)
  }else{
    data = data %>% 
      rename(value = nic)
  }
  
  data = data %>% 
    rename_at(old_code, ~"area_code") %>% 
    arrange(area_code, year_month) %>% 
    group_by(area_code) %>% 
    mutate(value = cumsum(value)) %>% 
    ungroup() %>% 
    group_by(area_code) %>% 
    mutate(value = as.numeric(value)) %>% 
    do(item = list(
      area_code = first(.$area_code),
      sequence = .$value,
      value = first(.$value))) %>% 
    .$item
  return(data)
}

# PLOT MAP FUNCTION

plot_map = function(map_data, boundary_data, max_val){
  
  output = highchart(type = "map") %>% 
    hc_add_series(
      data = map_data,
      name = "Items Since 2014",
      mapData = boundary_data,
      joinBy = "area_code",
      borderWidth = 0.2,
      borderColor = "black"
    ) %>% 
    hc_colorAxis(min = 0, max = max_val) %>% 
    hc_legend(
      layout = "horizontal",
      padding = 35,
      reversed = TRUE,
      floating = TRUE,
      align = "right"
    ) %>% 
    hc_motion(
      enabled = TRUE,
      axisLabel = "year",
      labels = sort(unique(data$year_month)),
      series = 0,
      updateIterval = 30,
      magnet = list(
        round = "floor",
        step = 0.18
      )
    ) %>% 
    hc_chart(marginBottom  = 100) %>% 
    hc_credits(enabled = T) %>% 
    hc_chart(zoomType = "xy")
  return(output)
}

# FUNCTION FOR LINE PLOTS

plot_line = function(data, items_or_nic, area_name){
  
  items_or_nic = sym(items_or_nic)
  area_name = sym(area_name)

  output = hchart(data, "spline", hcaes(year_month, !!items_or_nic, group = !!area_name)) %>% 
    hc_plotOptions(
      spline = list(
        marker = list(
          radius = 0
        )
      )
    ) %>% 
    hc_tooltip(table = T) %>% 
    hc_credits(enabled = T) %>% 
    hc_chart(zoomType = "x")
  return(output)
}

