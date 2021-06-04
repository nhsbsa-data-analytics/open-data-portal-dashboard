create_hc_base_plot = function(df, y_axis_text) {
  
  # Get the time frame
  x_axis_labels = df %>%
    dplyr::select(year_month) %>%
    unique() %>%
    dplyr::pull()
  
  # Initialise the highchart
  highcharter::highchart() %>%
    # Add the x axis
    highcharter::hc_xAxis(
      title = list(text = "Date"),
      categories = x_axis_labels,
      style = list(fontWeight = "bold", fontSize = "12px", fontFamily = "arial"),
      align = "center"
    ) %>%
    # Add the y axis
    highcharter::hc_yAxis(
      title = list(text = y_axis_text),
      style = list(fontWeight = "bold", fontSize = "12px", fontFamily = "arial"),
      align = "center"
    ) %>%
    # Add the highchart credit
    highcharter::hc_credits(enabled = TRUE)

}


add_palette = function(highchart_plot, n_series) {
  
  palette <- c(
    "#003087", # NHS Dark Blue
    "#41B6E6", # NHS Light Blue
    "#0072CE", # NHS Bright Blue
    "#00A9CE", # NHS Aqua Blue
    "#006747", # NHS Dark Green
    "#78BE20", # NHS Light Green
    "#009639", # NHS Green 
    "#00A499", # NHS Aqua Green
    "#330072", # NHS Purple
    "#AE2573", # NHS Pink
    "#ED8B00", # NHS Orange
    "#FAE100", # NHS Yellow
    "#7C2855", # NHS Dark Pink
    "#8A1538", # NHS Dark Red
    "#FFB81C"  #NHS Warm Yellow
  )
  
  # Add the colour pallette
  highchart_plot %>%
    highcharter::hc_colors(head(palette, n_series))
  
}

add_all_series = function(highchart_plot, df, filter_col, value_col) {
  
  # Get the categories for series
  filter_vals = df %>%
    dplyr::select(.data[[filter_col]]) %>%
    unique() %>%
    dplyr::pull() %>%
    as.character()
  
  # Loop over each filter val and add it to the plot
  # (in reverse order)
  for (filter_val in rev(filter_vals)) {
    highchart_plot <- highchart_plot %>%
      highcharter::hc_add_series(
        name = filter_val,
        data = df %>%
          dplyr::filter(.data[[filter_col]] == filter_val) %>%
          dplyr::select(.data[[value_col]]) %>%
          dplyr::pull()
      )
  }
  
  highchart_plot %>%
    # Add the colour pallette
    add_palette(., n_series = length(filter_vals)) %>%
    # Add the legend
    highcharter::hc_legend(reversed = T)
  
}

create_hc_line_plot = function(df, y_axis_text, filter_col, value_col) {
  
  df %>%
    # Create the base plot
    create_hc_base_plot(
      df = .,
      y_axis_text = y_axis_text
    ) %>%
    # Add x zoom
    highcharter::hc_chart(zoomType = "x") %>%
    # Add each series to the plot
    add_all_series(
      highchart_plot = .,
      df = df,
      filter_col = filter_col,
      value_col = value_col
    ) %>%
    # Add the tooltip
    highcharter::hc_tooltip(table = T)
  
}

# PLOT MAP FUNCTION

create_hc_map_plot = function(df, boundary, filter_col, value_col) {
  
  # Preprocess ODP data
  ds <- df %>% 
    # Standardise column names (to allow easier join to boundary file)
    dplyr::rename_at(filter_col, ~"area_code") %>%
    dplyr::rename_at(value_col, ~"value") %>%
    # Prep data for the motion plot 
    # https://jkunst.com/blog/posts/2016-04-12-adding-motion-to-choropleths/
    dplyr::group_by(area_code) %>% 
    dplyr::do(
      item = list(
        area_code = first(.$area_code),
        sequence = .$value,
        value = first(.$value))
    ) %>% 
    .$item
  
  # Create the motion plot
  highcharter::highchart(type = "map") %>% 
    # Add the data, join the boundary, define borders and value column
    highcharter::hc_add_series(
      data = ds,
      mapData = boundary,
      value = "value",
      joinBy = "area_code",
      borderWidth = 0.2,
      borderColor = "black"
    ) %>% 
    # Give the chart NHS colours
    highcharter::hc_colorAxis(
      minColor = "#41B6E6", # NHS Light Blue,
      maxColor = "#003087"  # NHS Dark Blue
    ) %>% 
    # Add a legend at the bottom
    highcharter::hc_legend(
      layout = "horizontal",
      padding = 35,
      reversed = TRUE,
      floating = TRUE,
      align = "right"
    ) %>% 
    # Add the motion
    highcharter::hc_motion(
      enabled = TRUE,
      axisLabel = "Time",
      labels = sort(unique(df$year_month)),
      series = 0,
      updateIterval = 30,
      magnet = list(
        round = "floor",
        step = 0.18
      )
    ) %>% 
    highcharter::hc_chart(marginBottom = 100) %>% 
    highcharter::hc_credits(enabled = TRUE) %>% 
    highcharter::hc_chart(zoomType = "xy")

}
