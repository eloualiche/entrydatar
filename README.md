entrydatar
======

Downloads and aggregates flat tables of entry statistics from the Quarterly Census of Employment and Wages program. Available on the [BLS website](http://www.bls.gov/cew/home.htm)

Files can be manually downloaded from this [page](http://www.bls.gov/cew/datatoc.htm).

### Available data
  
#### Quarterly Census of Employment and Wages (QCEW) 
Establishment level entry data
NAICS available from 1990 to 2015 and SIC from 1975 to 2000

#### Business Emplyment Dynamics (BED)
Firm level entry data 
Available at the naics (3 digits level) from 1992Q3 to 2015Q1 


### Vignettes: 
  - You can download specific cuts of the [QCEW](vignettes/download_data.Rmd)

### Installation
  -  Install the current version from [github](https://github.mit.edu/erikl/entrydatar) with

	```{r}
library(devtools)
devtools::install_github(
  "erikl/entrydatar", 
  host = "github.mit.edu/api/v3", 
  auth_token = "d2c545def9a8e8d8e3bd9be1fa18a815dafa09a8")
```


---------------------------
(c) Erik Loualiche
