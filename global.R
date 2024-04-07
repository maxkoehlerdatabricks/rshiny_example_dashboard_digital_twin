#####################################
# Prep
#####################################
# start interactive cluster and extract cluster id
# copy paste it in the "global Variable" section below within the "spark_connect" function
# Make sure a valid PAT token for the WS is create and in the local ".Renviron" file
# Note that you can open the ".Renviron" using usethis::edit_r_environ(), it should look like this 
# DATABRICKS_HOST="WS URL"
# DATABRICKS_TOKEN="PAT" 

#####################################
# Libraries
#####################################
library(sparklyr)
library(pysparklyr)
library(dbplyr)
library(shiny)
library(odbc)
library(DBI)
library(dplyr)
library(ggplot2)
library(shinyWidgets)
library(shinythemes)


#####################################
# Source Shiny Module Files
#####################################
source("./modules/curve_viewer_module.R")


#####################################
# Global Variables
#####################################

if (!spark_connection_is_open(sc)){
  sc <- spark_connect(
    cluster_id = "0407-145138-g81t25g1",
    method = "databricks_connect"
  )
  
}


curve_data <- tbl(sc, in_catalog("rshiny_max", "production_data", "twins_battery_coating_analysis")) %>% 
  as_tibble() %>%
 rename(process_time = "_index")

all_stations <- unique(curve_data$station_id)
measuremnet_selection <- c("dryerFanSpeed", "dryerTemperature")


now <- Sys.time()
recent_time <- Sys.time() - 20 * 60


#####################################
# Disconnect
#####################################
spark_disconnect(sc)



