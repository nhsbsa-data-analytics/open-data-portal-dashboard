# Define the pipe
`%>%` <- magrittr::`%>%`

# Define the url for the API call
base_endpoint <- "https://opendata.nhsbsa.net/api/3/action"

# Define the access methods
package_show_id <- "/package_show?id="
datastore_search_sql <- "/datastore_search_sql?"

# Define the dataset ID of interest
dataset_id <- "english-prescribing-data-epd"