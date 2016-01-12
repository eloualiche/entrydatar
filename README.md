entrydatar
======

Downloads and aggregates flat tables of entry statistics from the Quarterly Census of Employment and Wages and Business Employment Dynamics program. 

### Available data
  
#### Quarterly Census of Employment and Wages (QCEW) 
See the [BLS website](http://www.bls.gov/cew/home.htm) for more information.

Establishment level entry data.
NAICS available from 1990 to 2015 and SIC from 1975 to 2000.   

Files can be manually downloaded from this [page](http://www.bls.gov/cew/datatoc.htm).


#### Business Employment Dynamics (BED)
See the [BLS website](http://www.bls.gov/bdm/home.htm) for more information

Firm level entry data.
Data is available at the naics (3 digits level) from 1992Q3 to 2015Q1. 
We download an industry flat file directly from the [BLS](http://www.bls.gov/web/cewbd/bd_data_ind3.txt)


#### County Business Pattern (CBP)
See the Census [website](http://www.census.gov/econ/cbp/) for more information.
Annual data on business employment at the country

Files can be manually downloaded from this [page](http://www.census.gov/econ/cbp/download/)


### Vignettes: 
  - You can download specific cuts of the [QCEW](vignettes/qcew.Rmd)
  - You can download a clean version of the [CBP](vignettes/cbp.Rmd)


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
