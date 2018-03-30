## ---- warning = F, error = F, message = F--------------------------------
entrydatar::scb

## ---- warning = F, error = F, message = F--------------------------------
entrydatar::get_nbf(1980, 1998)

## ---- warning = F, error = F, message = F--------------------------------
skimr::skim(entrydatar::get_nbf(1980, 1998)[, .(nbi, nbf, cbf)])

