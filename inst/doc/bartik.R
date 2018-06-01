## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  library(data.table)
#  library(stringr)
#  library(Hmisc)
#  library(statar)
#  library(entrydatar)

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  read_cbp_sic <- function(year_target){
#  
#    # Download the data from the census at the county level
#    dt1 <- download_all_cbp(year_target, year_target, aggregation_level = "county")
#  
#    # clean the data
#    dt1[, fips := as.numeric(fipstate)*1000 + as.numeric(fipscty) ]
#    dt1 <- dt1[ !is.na(as.numeric(sic)) ]
#  
#    # impute employment for each size class
#    dt1[ empflag == "A", emp := 10     ]
#    dt1[ empflag == "B", emp := 60     ]
#    dt1[ empflag == "C", emp := 175    ]
#    dt1[ empflag == "E", emp := 375    ]
#    dt1[ empflag == "F", emp := 750    ]
#    dt1[ empflag == "G", emp := 1750   ]
#    dt1[ empflag == "H", emp := 3750   ]
#    dt1[ empflag == "I", emp := 7500   ]
#    dt1[ empflag == "J", emp := 17500  ]
#    dt1[ empflag == "K", emp := 37500  ]
#    dt1[ empflag == "L", emp := 75000  ]
#    dt1[ empflag == "M", emp := 100000 ]
#  
#    # aggregate and clean up
#    dt1[, fips := paste0(fipstate, fipscty) ]
#    dt1 <- dt1[, .(emp = sum(emp, na.rm = T)), by = list(fips, sic)][ order(sic, fips) ]
#    dt1[, fipsemp := sum(emp, na.rm = T), by = list(fips) ]
#    dt1[, date_y := year_target ]
#  
#    return(dt1)
#  }

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_emp_sic <- data.table()
#  for (year_iter in seq(1986, 1997)){
#      dt_emp_sic <- rbind(dt_emp_sic, read_cbp_sic(year_iter))
#  }
#  dt_emp_sic[]

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  read_cbp_naics <- function(year_target){
#  
#    # Download the data from the census at the county level
#    dt1 <- download_all_cbp(year_target, year_target, aggregation_level = "county")
#  
#    # clean the data and only keep 4 digits naics codes
#    dt1[, naics := gsub("\\D", "", naics) ]
#    dt1 <- dt1[ str_length(naics) == 4 ]
#  
#    # impute employment for each size class
#    dt1[ empflag == "A", emp := 10     ]
#    dt1[ empflag == "B", emp := 60     ]
#    dt1[ empflag == "C", emp := 175    ]
#    dt1[ empflag == "E", emp := 375    ]
#    dt1[ empflag == "F", emp := 750    ]
#    dt1[ empflag == "G", emp := 1750   ]
#    dt1[ empflag == "H", emp := 3750   ]
#    dt1[ empflag == "I", emp := 7500   ]
#    dt1[ empflag == "J", emp := 17500  ]
#    dt1[ empflag == "K", emp := 37500  ]
#    dt1[ empflag == "L", emp := 75000  ]
#    dt1[ empflag == "M", emp := 100000 ]
#  
#    # aggregate and clean up
#    dt1[, fips := paste0(fipstate, fipscty) ]
#    dt1 <- dt1[, .(emp = sum(emp, na.rm = T)), by = .(fips, naics)][ order(naics, fips) ]
#    dt1[, fipsemp := sum(emp, na.rm = T), by = list(fips) ]
#    dt1[, date_y := year_target ]
#  
#    return(dt1)
#  }

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_emp_naics <- data.table()
#  for (year_iter in seq(1998, 2016)){
#      dt_emp_naics <- rbind(dt_emp_naics, read_cbp_naics(year_iter))
#  }
#  dt_emp_naics[]

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_emp_sic[, share_ind_cty := emp / fipsemp ]
#  dt_emp_sic[, l_share_ind_cty := tlag(share_ind_cty, 1, time = date_y), by = .(fips, sic) ]
#  
#  dt_emp_naics[, share_ind_cty := emp / fipsemp ]
#  dt_emp_naics[, l_share_ind_cty := tlag(share_ind_cty, 1, time = date_y), by = .(fips, naics) ]

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_emp_sic[, fipsemp_clean := fipsemp - emp ]
#  dt_emp_sic[, d_fipsemp     := log(fipsemp_clean / tlag(fipsemp_clean, 1, time = date_y)), by = .(fips, sic) ]
#  
#  dt_emp_naics[, fipsemp_clean := fipsemp - emp ]
#  dt_emp_naics[, d_fipsemp     := log(fipsemp_clean / tlag(fipsemp_clean, 1, time = date_y) ), by = .(fips, naics) ]

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_emp_sic[, .(d_emp = wtd.mean(d_fipsemp, l_share_ind_cty, na.rm = T)), by = .(date_y, fips) ]
#  dt_emp_naics[, .(d_emp = wtd.mean(d_fipsemp, l_share_ind_cty, na.rm = T)), by = .(date_y, fips) ]

## ---- results='hide', warning = F, error = F, message = F, eval= F-------
#  dt_bartik <-
#    rbind(dt_emp_sic[, .(d_emp = wtd.mean(d_fipsemp, l_share_ind_cty, na.rm = T)), by = .(date_y, fips) ],
#          dt_emp_naics[, .(d_emp = wtd.mean(d_fipsemp, l_share_ind_cty, na.rm = T)), by = .(date_y, fips) ])
#  dt_bartik[]

