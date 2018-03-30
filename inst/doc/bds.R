## ---- warning = F, error = F, message = F, eval = T----------------------
library(entrydatar)
dt_firm  <- get_bds_cut(1977, 2014, "firm", "all")
DT::datatable(dt_firm)
dt_estab <- get_bds_cut(1977, 2014, "establishment", "agesic")
DT::datatable(dt_estab)

