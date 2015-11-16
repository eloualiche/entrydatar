# dt_res <- download_all_cbp()
#
# dt_tmp <- dt_res[, list(year, fipscty, naics) ]
# dt_tmp <- dt_tmp[ !is.na(naics) ]
# dt_tmp[, `:=`(naics3      = str_sub(naics, 1, 3),
#               naics3_type = str_sub(naics, 4, 6) ) ]
#
# dt_tmp[ naics3_type == "---" | naics3_type == "///" ]
# dt_tmp[ naics3_type == "---", list(naics, naics, naics3_type) ] %>% unique
# dt_tmp[ naics3_type == "///", list(naics, naics, naics3_type) ] %>% unique
#
#
# library(stringr)
#
# year <- 2000
# str_sub(year, 3, 4)
#
# s2000 %% 100
#
# dt <- fread("~/Downloads/naics.txt", header = T, sep="  ")
