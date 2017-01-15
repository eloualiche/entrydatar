## ---- results='hide', warning = F, error = F, message = F----------------
library(data.table, bit64)
library(entrydatar)

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt <- entrydatar::get_files_cut(data_cut = 10, year_start = 1990, year_end =1993,
#                                  path_data = "~/Downloads/", write = F)
#  dt

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt_naics <- entrydatar::get_files_cut(data_cut = 28,
#                                        industry = "naics",
#                                        year_start = 1990, year_end = 2015,
#                                        path_data = "~/Downloads/", write = F)
#  dt_naics

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  dt_naics <- entrydatar::tidy_qcew(dt_naics,
#                                    frequency = "month")
#  dt_naics

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  # Enter the address directly from the html address
#  wayback_suffix <- "https://web.archive.org/web/20141101135821"  # suffix for November 1st, 2014
#  # Or enter the exact date at which date it has been crawled:
#  wayback_suffix <- 20141101135821
#  
#  # execute adding the wayback option
#  dt_naics <- entrydatar::get_files_cut(data_cut = 28,
#                                        industry = "naics",
#                                        year_start = 1990,
#                                        year_end = 2013,       # try not to ask for data from the future
#                                        url_wayback = wayback_suffix,
#                                        path_data = "~/Downloads/", write = F)
#  dt_naics

