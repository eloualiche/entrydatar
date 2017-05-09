`entrydatar` 
R package for data on U.S. firm level entry
======

Downloads and aggregates flat tables of entry statistics from the *Quarterly Census of Employment and Wages* and *Business Employment Dynamics program* and the *County Business Patterns*.

## Available data

### Quarterly Census of Employment and Wages (QCEW)

See the [BLS website](http://www.bls.gov/cew/home.htm) for more information.

Establishment level entry data.
NAICS available from 1990 to 2016 and SIC from 1975 to 2000.   

Files can be manually downloaded from this [page](http://www.bls.gov/cew/datatoc.htm).


### Business Employment Dynamics (BED)
See the [BLS website](http://www.bls.gov/bdm/home.htm) for more information

Firm level entry data.
Data is available at the naics (3 digits level) from 1992Q3 to 2015Q1.
We download an industry flat file directly from the [BLS](http://www.bls.gov/web/cewbd/bd_data_ind3.txt)


### County Business Pattern (CBP)
See the Census [website](http://www.census.gov/econ/cbp/) for more information.
Annual data on business employment at the county level.

Files can be manually downloaded from this [page](http://www.census.gov/econ/cbp/download/).

Left to Do on CBP:
- Some of the data is on `naics` and some on `sic`. Is there an harmonized dataset.
- `tidy` function on cbp is not finished

### Other datasets (In progress)

  - Local Area Unemployment Statistics from the BLS: [LAU](https://www.bls.gov/lau/#tables)
```get_lau_data(years = seq(1990, 2016), path_data  = "./")```

## Vignettes:
  - How to download specific cuts of the [QCEW](vignettes/qcew.Rmd)
  - How to download a clean version of the [CBP](vignettes/cbp.Rmd)
  - How to download a clean version of the [BED](vignettes/bed.Rmd)


## Installation
  -  Install the current version from [github](https://github.mit.edu/erikl/entrydatar) with

```{r}
library(devtools)
devtools::install_github("eloualiche/entrydatar")
```


## Work in progress (to do list)
  - Load QCEW directly from local downloaded files
  



---------------------------
(c) Erik Loualiche
