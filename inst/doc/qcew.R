## ---- results='hide', warning = F, error = F, message = F----------------
library(data.table, bit64)
library(entrydatar)

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt_agg <- get_files_cut(
#    data_cut = 10,
#    year_start = 1990, year_end =1993,
#    path_data = "~/Downloads/", write = F)
#  dt_agg

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt_naics <- get_files_cut(
#    data_cut = 28,
#    industry = "naics",
#    year_start = 1990, year_end = 2015,
#    path_data = "~/Downloads/", write = F)
#  dt_naics

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt_naics <- get_files_cut(
#    data_cut = 28,
#    industry = "naics",
#    year_start = 1990, year_end = 2015,
#    path_data = "~/Downloads/", write = F)
#  dt_naics

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt_naics <- entrydatar::tidy_qcew(dt_naics,
#                                    frequency = "month")
#  dt_naics[]

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#          year quarter industry_code area_fips own_code size_code agglvl_code month emplvl
#       1: 1990       1          1011     01001        5         0          73     1    149
#       2: 1990       1          1011     01003        5         0          73     1    632
#       3: 1990       1          1011     01005        5         0          73     1    290
#       4: 1990       1          1011     01007        5         0          73     1    329
#       5: 1990       1          1011     01009        5         0          73     1    216
#      ---
#  513884: 1990       4          1028     78010        1         0          73    12    208
#  513885: 1990       4          1028     78010        2         0          73    12   2972
#  513886: 1990       4          1028     78020        1         0          73    12      1
#  513887: 1990       4          1028     78030        1         0          73    12    356
#  513888: 1990       4          1028     78030        2         0          73    12   4034

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  # Enter the address directly from the html address
#  wayback_suffix <- "https://web.archive.org/web/20141101135821"  # suffix for November 1st, 2014
#  # Or enter the exact date at which date it has been crawled:
#  wayback_suffix <- 20141101135821
#  
#  # execute adding the wayback option
#  dt_naics <- get_files_cut(
#    data_cut = 28,
#    industry = "naics",
#    year_start = 1990,  year_end = 2015,       # try not to ask for data from the future
#    url_wayback = wayback_suffix,
#    path_data = "~/Downloads/", write = F)
#  dt_naics

