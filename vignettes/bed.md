Downloads data from the BED website. Of main importance is the flat file with firm level count by industry (3 digits naics) every quarter. The flat file is at the bottom of this [page](http://www.bls.gov/bdm/bdmind3.htm) under this [url](http://www.bls.gov/web/cewbd/bd_data_ind3.txt).

Note that there is also a [ftp](http://download.bls.gov/pub/time.series/bd/) with other data.

For example to start and get the BED industry data:

``` r
library(entrydatar)
dt_ind <- get_bed_data("industry")
dt_ind
```

Take for example industry `naics = 111`, *Crop Production*. The data comes from two tables:

+ [Table 7](https://www.bls.gov/web/cewbd/table7_1_ind3.txt)
  + *Private sector establishments by direction of employment change, as percent of total establishments, seasonally adjusted*
  + `ent_cnt` is *Establishment gaining jobs, Opening establishments*
  + `exit_cnt` is *Establishment losing jobs, Closing establishments*
  + `nent_cnt` is the difference between the number of opening establishments and the number of closing establishments. 
  
+ [Table 3](https://www.bls.gov/web/cewbd/table3_1_ind3.txt)
  + *Private sector gross job gains and losses, as a percent of employment, seasonally adjusted*
  + `ent_emp` is *Gross job gains, Opening establishments*
  + `exit_emp` is *Gross job losses, Closing establishments*
  + `nent_emp` Net change is the difference between total gross job gains and total gross job losses.


# In progress

# Other informations
Business Employment Dynamics Program Contacts
Please contact us via email at: BDMInfo@bls.gov or by phone on 202-691-6553.



------------------------------------------------------------------------

1.  Erik Loualiche
