# Group sum function
group_sum <- function(df, col, ...) {
  
  df %>%
    dplyr::group_by(...) %>% 
    dplyr::summarise({{col}} := sum(.data[[col]])) %>% 
    dplyr::ungroup()
  
} 

# Group max function
group_max <- function(df, col, ...) {
  
  df %>%
    dplyr::group_by(...) %>% 
    dplyr::summarise({{col}} := max(.data[[col]])) %>% 
    dplyr::ungroup()
  
} 

# Create reactable table
create_reactable <- function(df, col) {
  
  df %>%
    reactable::reactable(
      filterable = TRUE,
      highlight = TRUE,
      compact = TRUE,
      showSortable = TRUE,
      bordered = TRUE,
      pagination = FALSE,
      defaultSelected = seq(1, 5),
      selection = "multiple",
      onClick = "select",
      columns = list(
        items = reactable::colDef(
          name = col, 
          format = reactable::colFormat(
            separators = TRUE, 
            digits = 0
          )
        )
      )
    )
  
}

create_boundary = function(url, filter_col){
  
  url %>%
    sf::read_sf() %>% 
    # Reproject data onto a suitable CRS (the British National Grid has an EPSG 
    # code of 27700
    sf::st_as_sf(crs = 27700) %>% 
    dplyr::rename_at(filter_col, ~ "area_code") %>%
    dplyr::select(area_code) %>% 
    geojsonsf::sf_geojson() %>% 
    jsonlite::fromJSON(simplifyVector = F)

}

