## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  library(entrydatar)
#  dt_raw <- download_all_cbp(1990, 1990)
#  dt_raw

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_county_level   <- download_all_cbp(1990, 1990,
#                                        aggregation_level = "county")
#  dt_national_level <- download_all_cbp(1990, 1990,
#                                        aggregation_level = "US")

## ---- results='hide', warning = F, error = F, message = F, eval = F------
#  # dt_tidy <- entrydatar::tidy_cbp(dt_raw, 1990, 1990)
#  # dt_tidy

