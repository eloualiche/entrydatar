## ---- warning = F, error = F, message = F--------------------------------
entrydatar::scb

## ---- warning = F, error = F, message = F, eval = F----------------------
#  entrydatar::get_nbf(1980, 1998)

## ---- warning = F, error = F, message = F, eval=F------------------------
#  > skimr::skim(entrydatar::get_nbf(1980, 1998)[, lapply(.SD, as.numeric), .SDcols = c("nbi", "nbf", "cbf")])
#  Skim summary statistics
#   n obs: 180
#   n variables: 3
#  
#  Variable type: numeric
#    variable missing complete   n     mean      sd     min      p25  median      p75     max     hist
#  1      cbf       0      180 180  3276.13 2699.21   190.8  1614.83  2684    3941.58 15757.6 ▇▇▂▂▁▁▁▁
#  2      nbf       0      180 180   121.34    4.42   112     118.5    121.1   124.53   137.9 ▂▃▇▅▃▁▁▁
#  3      nbi       0      180 180 54048.79 5149.2  40648   50663.25 54809   57616.75 65691   ▁▂▃▆▇▇▂▂

