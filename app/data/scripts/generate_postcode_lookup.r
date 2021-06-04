
# GENERATE POSTCODE LOOKUP

# LIBRARIES

library(jsonlite)
library(dplyr)
library(readr)

# LOOKUP URLS

ccg_to_stp_url = "https://opendata.arcgis.com/api/v3/datasets/a458c272484743aa9caa25619ccbe1ac_0/downloads/data?format=csv&spatialRefId=4326"
stp_to_region_url = "https://opendata.arcgis.com/api/v3/datasets/00613813dd4b4f2dba16268720b50bd4_0/downloads/data?format=csv&spatialRefId=4326"

# LOOKUP DATA

ccg_stp_lookup = read_csv(ccg_to_stp_url)
stp_region_lookup = read_csv(stp_to_region_url)

# DEFINE LATEST EPD DATA MONTH

latest_epd_month = 202103

# GENERATE YEEAR_LIST AND MONTH_LIST

year_list = c(as.character(seq(2014, substr(latest_epd_month, 1, 4))))
month_list = c(as.character(sprintf("%02d", 1:12)))

# GENERATE VECTOR OF YEAR_MONTHS

expand_list = expand.grid(year_list, month_list) %>% 
  mutate(
    year_month_cat = paste0(Var1, Var2),
    year_month_cat = as.integer(year_month_cat)
  ) %>% 
  filter(year_month_cat <= latest_epd_month) %>% 
  arrange(year_month_cat) %>% 
  mutate(year_month_cat = as.character(year_month_cat)) %>% 
  select(year_month_cat) %>% 
  pull()

# LIST FOR RESULTS

results = list()

# FUNCTION TO RETRIEVE POSTCODE INFO FROM API

get_postcode_info = function(year_month){
  sql_query = URLencode(paste0("https://opendata.nhsbsa.net/api/3/action/datastore_search_sql?resource_id=EPD_202103&sql=SELECT distinct replace(trim(postcode), ' ', '')  as  postcode from `EPD_", year_month, "`"))
  month = fromJSON(sql_query)
  data = month$result$result$records
  return(data)
}

# GET DATA

for(i in expand_list){
  results[[i]] = get_postcode_info(i)
}

# BIND ROWS

results = results %>% 
  bind_rows() %>% 
  distinct() %>% 
  filter(postcode != "" & postcode != "-") %>% 
  left_join(
    read_rds("data/nspl_slim.Rds") %>% 
      filter(postcode %in% results$postcode) %>% 
      select(
        postcode,
        ccg_code = pco_code
      ) %>% 
      inner_join(
        ccg_stp_lookup %>% 
          select(
            ccg_code = CCG21CD,
            ccg_name = CCG21NM,
            stp_code = STP21CD,
            stp_name = STP21NM
          ) %>% 
          inner_join(
            stp_region_lookup %>% 
              select(
                stp_code = STP20CD,
                region_code = NHSER20CD,
                region_name = NHSER20NM
              ),
            by = "stp_code"
          ),
        by = "ccg_code"
      ),
    by = "postcode"
  )

# MERGE POSTCODE DATA ONTO RESULTS

results_match = results %>% 
  filter(!is.na(ccg_code))

# DETERMINE INFOR FROM POSTCODE SUBSTR_2

results_2_sub = results %>% 
  filter(!postcode %in% results_match$postcode) %>% 
  select(postcode) %>% 
  mutate(postcode_substr = substr(postcode, 1, nchar(postcode) - 2)) %>% 
  inner_join(
    results_match %>% 
      mutate(postcode_substr = substr(postcode, 1, nchar(postcode) - 2)) %>% 
      select(-postcode),
    by = "postcode_substr"
  ) %>% 
  distinct() %>% 
  select(-postcode_substr) %>% 
  mutate(n = 1) %>% 
  group_by(postcode) %>% 
  mutate(n = sum(n)) %>% 
  ungroup() %>% 
  filter(n == 1) %>% 
  select(-n)

# DETERMINE INFOR FROM POSTCODE SUBSTR_3

results_3_sub = results %>% 
  filter(!postcode %in% results_match$postcode) %>% 
  filter(!postcode %in% results_2_sub$postcode) %>% 
  select(postcode) %>% 
  mutate(postcode_substr = substr(postcode, 1, nchar(postcode) - 3)) %>% 
  inner_join(
    results_match %>% 
      mutate(postcode_substr = substr(postcode, 1, nchar(postcode) - 3)) %>% 
      select(-postcode),
    by = "postcode_substr"
  ) %>% 
  distinct() %>% 
  select(-postcode_substr) %>% 
  mutate(n = 1) %>% 
  group_by(postcode) %>% 
  mutate(n = sum(n)) %>% 
  ungroup() %>% 
  filter(n == 1) %>% 
  select(-n)

# FINAL RESULTS
# NOTE: 2 UNALLOCATED POSTCODES

results_total = results_final %>% 
  rbind(results_2_sub) %>% 
  rbind(results_3_sub)

# GET MONTHLY ITEM AND NIC SUMS

get_items_nic = function(year_month){
  sql_query = URLencode(paste0("https://opendata.nhsbsa.net/api/3/action/datastore_search_sql?resource_id=EPD_202103&sql=SELECT year_month, replace(postcode, ' ', '') as postcode, sum(items) as items, sum(nic) as nic from `EPD_", year_month, "` group by year_month, replace(postcode, ' ', '')"))
  month = fromJSON(sql_query)
  data = month$result$result$records
  return(data)
}

# LIST FOR ITEMS AND NIC

results_items = list()

# GET DATA: TAKES ~3 MINS

for(i in expand_list){
  results_items[[i]] = get_items_nic(i)
}

# BIND ROWS AND MERGE WITH POSTCODE DATA

results_items_final = results_items %>% 
  bind_rows() %>% 
  inner_join(results_total, by = "postcode") %>% 
  arrange(year_month, postcode)

# CHECK FOR NAS

colSums(is.na(results_items_final))

# SAVE DATA

saveRDS(results_items_final, "data/total_items_nic.Rds")

#-------------------------------------------------------------------------------