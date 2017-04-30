Downloads data from the BED website. Of main importance is the flat file with firm level count by industry (3 digits naics) every quarter. The flat file is at the bottom of this [page](http://www.bls.gov/bdm/bdmind3.htm) under this [url](http://www.bls.gov/web/cewbd/bd_data_ind3.txt).

Note that there is also a [ftp](http://download.bls.gov/pub/time.series/bd/) with other data.

For example to start and get the BED industry data:

``` r
library(entrydatar)
dt_ind <- get_bed_data("industry")
dt_ind
```

------------------------------------------------------------------------

1.  Erik Loualiche
