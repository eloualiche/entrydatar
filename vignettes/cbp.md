We download data from the County Business Pattern (CBP). Data is available for the period from 1986 to 2014 at an annual frequency.
The most detailed cut of the data incorporates size, country and industry (4 digits) employment and businesses.
The data is directly retrieved from the Census [website](http://www.census.gov/programs-surveys/cbp.html)

For example if we would like the raw data:

``` r
library(entrydatar)
dt_raw <- download_all_cbp(1990, 1990)
dt_raw
```

The data is by default aggregated at the county level. I allow different level of aggregations using variable `aggregation_level`. The `aggregation_level` variable is detailed in a table below. Calling variable without the default is now:

``` r
dt_county_level   <- download_all_cbp(1990, 1990,
                                      aggregation_level = "county")
dt_national_level <- download_all_cbp(1990, 1990,
                                      aggregation_level = "US")
```

### Some more information about data layout and availability

-   By Geography:
-   Metro area data start with 1993.
-   ZIP Code data start with 1994
-   Congressional District data started in 2013.
-   LFO breakout for States starts with 2010.
-   Island Area data and LFO breakout for U.S. start with 2008.
-   Puerto Rico data start with 1998.

-   By Industry:
-   4-digit SIC code from 1986 to 1997
-   6-digit NAICS code from 1998 to 2014. New flags added after 2007.

|                                                                  |
|------------------------------------------------------------------|
| | Variable Name | Description |                                  |
| |---------------------------|----------------------------------| |
| | | |                                                            |
| | Variable | |                                                   |
| | `emp` | Total Mid-March Employees |                            |
| | `qp1` | First Quarter Payroll ($1,000) |                       |
| | `ap` | Total Annual Payroll ($1,000) |                         |
| | `est` | Total Number of establishments |                       |
| | | |                                                            |
| | Size | |                                                       |
| | `N1_4` | 1-4 Employee Size Class |                             |
| | `N5_9` | 5-9 Employee Size Class |                             |
| | `N10_19` | 10-19 Employee Size Class |                         |
| | `N20_49` | 20-49 Employee Size Class |                         |
| | `N50_99` | 50-99 Employee Size Class |                         |
| | `N100_249` | 100-249 Employee Size Class |                     |
| | `N250_499` | 250-499 Employee Size Class |                     |
| | `N500_999` | 500-999 Employee Size Class |                     |
| | `N1000` | 1000 or More Employee Size Class |                   |
| | `N1000_1` | 1000-1499 Employee Size Class |                    |
| | `N1000_2` | 1500-2499 Employee Size Class |                    |
| | `N1000_3` | 2500-4999 Employee Size Class |                    |
| | `N1000_4` | 5000 or More Employee Size Class |                 |
| | | |                                                            |
| | Flags | |                                                      |
| | `empflag` | Size class replaced withheld |                     |
| | | emp and payroll replaced by 0 |                              |
| | `fipstate` | FIPS State Code |                                 |
| | `fipcscty` | FIPCS County Code |                               |
| | `censtate` | Census State Code |                               |
| | `cencty` | Census County Code |                                |

Informative flags are the `empflag` about data suppression. It denotes employment size class for data withheld to avoid disclosure (confidentiality) or withheld because data do not meet publication standards. The aggregate size class is indicated by letters from `a` to `m`. `lfo` informs about the legal organizational form of the firms considered. Definitions of the flags are in the following table:

|                                                                         |
|-------------------------------------------------------------------------|
| | Data Flag | Description |                                             |
| |----------------------------|----------------------------------------| |
| | | |                                                                   |
| | Employment Flag | |                                                   |
| | `EMPFLAG` | |                                                         |
| | `a` | 0-19 |                                                          |
| | `b` | 20-99 |                                                         |
| | `c` | 100-249 |                                                       |
| | `e` | 250-499 |                                                       |
| | `f` | 500-999 |                                                       |
| | `g` | 1,000-2,499 |                                                   |
| | `h` | 2,500-4,999 |                                                   |
| | `i` | 5,000-9,999 |                                                   |
| | `j` | 10,000-24,999 |                                                 |
| | `k` | 25,000-49,999 |                                                 |
| | `l` | 50,000-99,999 |                                                 |
| | `m` | 100,000 or More |                                               |
| | | |                                                                   |
| | Legal Form of Organization | |                                        |
| | `LFO` | |                                                             |
| | `-` | All Establishments |                                            |
| | `C` | Corporations |                                                  |
| | `Z` | S-Corporations |                                                |
| | `S` | Sole Proprietorships |                                          |
| | `P` | Partnernhips |                                                  |
| | `N` | Non-Profits |                                                   |
| | `G` | Government |                                                    |
| | `O` | Other |                                                         |
| | | |                                                                   |
| | Noise Flag | |                                                        |
| | `EMP_NF` | Total Mid-March Employees Noise Flag |                     |
| | `QP1_NF` | Total First Quarter Payroll Noise Flag |                   |
| | `AP_NF` | Total Annual Payroll Noise Flag |                           |
| | `G` | 0 to &lt; 2% noise (low noise) |                                |
| | `H` | 2 to &lt; 5% noise (low noise) |                                |
| | `D` | |                                                               |
| | `D` | Withheld (see records layout) |                                 |
| | `S` | Withheld (see records layout) |                                 |

To Download different version of the dataset the match is:
----------------------------------------------------------

| Aggregation Argument | Description            | Data layout                               |
|----------------------|------------------------|-------------------------------------------|
| `county`             | county level (default) |                                           |
| `US`                 | national               | [US](../tables/us_lfo_layout.txt)         |
| `MSA`                | metropolitan area      | [MSA](../tables/metro_area_layout,txt)    |
| `state`              | state level            | [State](../tables/state_x_lfo_layout.txt) |

------------------------------------------------------------------------

------------------------------------------------------------------------

For something a bit tidier we gather the data around year, geography, industry and size. *Not yet implemented*.

``` r
# dt_tidy <- entrydatar::tidy_cbp(dt_raw, 1990, 1990)
# dt_tidy
```

------------------------------------------------------------------------

1.  Erik Loualiche
