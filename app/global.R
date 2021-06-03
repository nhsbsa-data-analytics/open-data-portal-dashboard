# Define the url for the API call
base_endpoint <- "https://opendata.nhsbsa.net/api/3/action"

# Define the access methods
access_package_show_id <- "/package_show?id="
access_datastore_search_sql <- "/datastore_search_sql?resource_id=1&sql=" # hack the resource_id to be 1 for simplicity

# Define the dataset ID of interest
dataset_id <- "english-prescribing-data-epd"

# Load magrittr (for it's pipe function %>%)
library(magrittr)