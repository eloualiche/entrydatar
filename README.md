
entrydatar: download and clean data on U.S. firms' entry
======

[![Build Status](https://travis-ci.org/eloualiche/entrydatar.svg?branch=master)](https://travis-ci.org/eloualiche/entrydatar)
[![codecov](https://codecov.io/gh/eloualiche/entrydatar/branch/master/graph/badge.svg)](https://codecov.io/gh/eloualiche/entrydatar)



Downloads and aggregates flat tables of entry statistics from the *Quarterly Census of Employment and Wages* and *Business Employment Dynamics program* and the *County Business Patterns*. See details of this file and the vignettes for other commands for other public downloads.




## Available data

### Quarterly Census of Employment and Wages (QCEW)

  + See the [BLS website](http://www.bls.gov/cew/home.htm) for more information.
  + Establishment level entry data.
  + NAICS available from 1990 to 2016 and SIC from 1975 to 2000.   
  + Files can be manually downloaded from this [page](http://www.bls.gov/cew/datatoc.htm).


### Business Employment Dynamics (BED)

  + See the [BLS website](http://www.bls.gov/bdm/home.htm) for more information
  + Establishment level entry data.
  + Data is available at the naics (3 digits level) from 1992Q3 to 2015Q1.
  + We download an industry flat file directly from the [BLS](http://www.bls.gov/web/cewbd/bd_data_ind3.txt)


### County Business Pattern (CBP)

  + See the Census [website](http://www.census.gov/econ/cbp/) for more information.
  + Annual data on business employment at the county level.
  + Files can be manually downloaded from this [page](http://www.census.gov/econ/cbp/download/).
  + Left to Do on CBP:
    [ ] Some of the data is on `naics` and some on `sic`. Is there an harmonized dataset.
    [ ] `tidy` function on cbp is not finished


## Other datasets (In progress)

  + *Local Area Unemployment Statistics* from the BLS: [LAU](https://www.bls.gov/lau/#tables)
     ```get_lau_data(years = seq(1990, 2016), path_data  = "./")```
  + *Business Dynamics Statistics* from the Census: [BDS](https://www.census.gov/ces/dataproducts/bds/)
     ```get_bds_cut(1977, 2014, "firm", "agesic")```
  + Business Formation from the BEA, *Survey of Current Business*: [NBF](https://www.bea.gov/scb/pdf/NATIONAL/BUSCYCLE/1996/0296cpgs.pdf)
     ```get_nbf(years = seq(1948, 1994))```


## Vignettes:

  + How to download specific cuts of the [QCEW](vignettes/qcew.Rmd)
  + How to download a clean version of the [CBP](vignettes/cbp.Rmd)
  + How to download a clean version of the [BED](vignettes/bed.Rmd)
  + How to download a clean version of the [BDS](vignettes/bds.Rmd)
  + How to download a clean version of the [NBF](vignettes/nbf.Rmd)


## Installation

  +  Install the current version from [github](https://github.com/eloualiche/entrydatar) with

```{r}
library(devtools)
devtools::install_github("eloualiche/entrydatar")
```

## Examples

  + How to construct a *Bartik shock* using the [CBP](vignettes/bartik.Rmd)
  

## Work in progress (to do list)
  
  + [ ] Load QCEW directly from local downloaded files
  + [ ] Stable version of Quarterly Workforce Indicator. See vignette for documentation [QWI](vignettes/qwi.Rmd)



---------------------------
(c) Erik Loualiche
