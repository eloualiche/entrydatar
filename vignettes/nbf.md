The dataset is small so it is available directly with the package (no
download required). It includes three variables:

1.  `nbf`: Index of net business formation (1967=100)
2.  `nbi`: Number of new business incorporations (number)
3.  `cbf`: Current liabilities of business failures, NSA (mil. $)

Load it with:

``` r
entrydatar::scb
```

    ##      date_ym nbf_annual   nbf nbi_annual   nbi cbf_annual    cbf
    ##   1:  194801      101.1 115.7      95462  9380      234.6   13.0
    ##   2:  194802      101.1 107.5      95462  8329      234.6   25.6
    ##   3:  194803      101.1 105.0      95462  8349      234.6   17.5
    ##   4:  194804      101.1 104.5      95462  8396      234.6   15.3
    ##   5:  194805      101.1 103.7      95462  8064      234.6   13.8
    ##  ---                                                            
    ## 560:  199408      125.5 125.8     741059 64844    28943.9 2106.8
    ## 561:  199409      125.5 125.3     741059 64564    28943.9 3434.0
    ## 562:  199410      125.5 124.6     741059 60488    28943.9 2023.1
    ## 563:  199411      125.5 127.9     741059 64542    28943.9 2511.8
    ## 564:  199412      125.5 127.3     741059 62908    28943.9 3108.0

There is also a function like the other in this package to access an
interval:

``` r
entrydatar::get_nbf(1980, 1998)
```

    ##      date_ym nbf_annual   nbf nbi_annual   nbi cbf_annual    cbf
    ##   1:  198001      129.9 137.9     531519 44230     4634.9  243.1
    ##   2:  198002      129.9 137.1     531519 44175     4634.9  190.8
    ##   3:  198003      129.9 134.9     531519 43359     4634.9  274.2
    ##   4:  198004      129.9 129.8     531519 42240     4634.9  428.2
    ##   5:  198005      129.9 128.5     531519 42710     4634.9  381.1
    ##  ---                                                            
    ## 176:  199408      125.5 125.8     741059 64844    28943.9 2106.8
    ## 177:  199409      125.5 125.3     741059 64564    28943.9 3434.0
    ## 178:  199410      125.5 124.6     741059 60488    28943.9 2023.1
    ## 179:  199411      125.5 127.9     741059 64542    28943.9 2511.8
    ## 180:  199412      125.5 127.3     741059 62908    28943.9 3108.0

Note that the data only extends to 1994 (included).

Quick summary stats of the dataset"

``` r
skimr::skim(entrydatar::get_nbf(1980, 1998)[, .(nbi, nbf, cbf)])
```

    ## Skim summary statistics
    ##  n obs: 180 
    ##  n variables: 3 
    ## 
    ## Variable type: integer 
    ##   variable missing complete   n     mean     sd   min      p25 median
    ## 1      nbi       0      180 180 54048.79 5149.2 40648 50663.25  54809
    ##        p75   max     hist
    ## 1 57616.75 65691 ▁▂▃▆▇▇▂▂
    ## 
    ## Variable type: numeric 
    ##   variable missing complete   n    mean      sd   min     p25 median
    ## 1      cbf       0      180 180 3276.13 2699.21 190.8 1614.83 2684  
    ## 2      nbf       0      180 180  121.34    4.42 112    118.5   121.1
    ##       p75     max     hist
    ## 1 3941.58 15757.6 ▇▇▂▂▁▁▁▁
    ## 2  124.53   137.9 ▂▃▇▅▃▁▁▁

------------------------------------------------------------------------

From the [original
file](https://www.bea.gov/scb/pdf/NATIONAL/BUSCYCLE/1996/0296cpgs.pdf),
we have the sources of the information gathered here:

-   Mr. Neil DiBernardo (new business incorporations and business
    failures), *The Dun & Bradstreet Corporation, Economic Analysis
    Department* (Other component data are not available to the public.)

------------------------------------------------------------------------

1.  Erik Loualiche
