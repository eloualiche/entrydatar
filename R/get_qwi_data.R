## ## ' Group all the functions
## ## '
## ## ' @note downloads data from the Quarterly Census for Employment and Wages
## ## '   program, for desired years, splitting data by the aggregation level codes
## ## '   and exporting them into separate files sorted by year and aggregation level
## ## ' @note: we intend to have a single file for each aggregation level, but it is
## ## ' more convenient to merge the individual files using an external command line
## ## ' tool like cat
## ## '








## #' Other code: loads data.table with option to write it for a given cut
## ## #'
## ## #' @param path_data: where do we store the data
## ## #' @param year_start: start year for which we want data
## ## #' @param year_end: end year for which we want data
## ## #' @param industry: download naics or sic data
## ## #' @param frequency: download the quarterly files or the yearly files (default is quarterly)
## ## #' @param download: if empty do download the file from the BLS website, if not use a local version
## ## #' @param url_wayback: allows to specify the path in internet wayback machine that kept some of the archive
## ## #' @param write: save it somewhere
## ## #' @param verbose: useful for looking all the downloads link (debugging mode)
## ## #' @return data.table aggregate
## ## #' @examples
## ## #'   dt <- get_files_cut(data_cut = 10, year_start = 1990, year_end =1993,
## ## #'                       path_data = "~/Downloads/", write = T)
## ## #' @export
## ## get_qwi_cut <- function(
## ##   data_cut    = 10,
## ##   year_start  = 1990,
## ##   year_end    = 2015,
## ##   industry    = "naics",
## ##   frequency   = "quarter",
## ##   path_data   = "~/Downloads/tmp_data/",
## ##   download    = "",
## ##   url_wayback = "",
## ##   write       = F,
## ##   verbose     = F
## ## ){


## ##     dt_res <- data.table()

## ##     subdir <- random::randomStrings(n=1, len=5, digits=TRUE, upperalpha=TRUE,
## ##                                     loweralpha=TRUE, unique=TRUE, check=TRUE)   # generate a random subdirectory to download the data
## ##       message(paste0("# -----------------------------------------------------\n",
## ##                    "# Creating temporary directory for all the downloads: '", path_data, subdir, "' "))
## ##     dir.create(paste0(path_data, subdir))


## ##   # ------------------------------------------------------------------------
## ##   if(industry == "naics"){

## ##     # NON SIZE DATA SAMPLE
## ##     if ( prod(data_cut <= 20 | data_cut >= 30) ){          # make sure all the elements are of the same type

## ##       for (year_iter in seq(year_start, year_end)) {

## ##           message(paste0("\n# Processing data for year ", toString(year_iter)," and ", industry, " industry type."))
## ##           if (download == ""){
## ##               message("# Download in progress ... ")
## ##               file_name <- download_qcew_data(target_year = year_iter,
## ##                                               industry = industry, frequency = frequency,
## ##                                               path_data = paste0(path_data, subdir, "/"),
## ##                                               url_wayback = url_wayback, verbose = verbose)
## ##               df <- fread(paste0(path_data, subdir, "/", file_name) ) #, colClasses = c(disclosure_code = "character") )
## ##           } else {
## ##               message("# Read file locally ... ")
## ##               system( paste0("tar -xvzf ", "'", download, year_iter, "_qtrly_singlefile.zip' ", "-C ", path_data, subdir ) )
## ##               df <- fread(paste0(path_data, subdir, "/", paste0(year_iter, ".q1-q4.singlefile.csv")) ) #, colClasses = c(disclosure_code = "character") )
## ##           }

## ##           dt_split <- df[ agglvl_code %in% data_cut ]
## ##           vec_tmp <- dt_split$disclosure_code          # only character

## ##           dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]
## ##           dt_split$disclosure_code <- vec_tmp
## ##                                         # this clean up is not necessary to keep disclosure codes intact

## ##                                         # cleaning up
## ##                                         # unlink(paste0(path_data, subdir), recursive = T)
## ##           message("")
## ##           if (download == ""){
## ##               file.remove( paste0(path_data, subdir, "/", file_name) )
## ##           } else {
## ##               system(paste0("rm ", path_data, subdir, "/*.csv"))
## ##           }

## ##           dt_res <- rbind(dt_res, dt_split, fill = T)
## ##       }


## ##    # ------------------------------------------------------------------------
## ##    # SIZE DATA: downloading only quarter version for now (ignore frequency)
## ##     } else if ( prod(data_cut >= 20 & data_cut <= 30) ){

## ##         for (year in seq(year_start, year_end)) {

## ##             message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type. Size subdivision"))

## ##             file_name <- download_qcew_size_data(target_year = year,
## ##                                                  industry = industry,
## ##                                                  path_data = paste0(path_data, subdir, "/"),
## ##                                                  url_wayback = url_wayback)

## ##             df <- fread( paste0(path_data, subdir, "/", file_name) )

## ##             dt_split <- df[ agglvl_code %in% data_cut ]

## ##             dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]
## ##             # setnames(dt_split, c("qtrly_estabs_count", "lq_qtrly_estabs_count"),
## ##             # c("qtrly_estabs", "lq_qtrly_estabs") )
## ##             # cleaning up
## ##             message("")
## ##             file.remove( paste0(path_data, subdir, "/", file_name) )

## ##             dt_res <- rbind(dt_res, dt_split, fill = T)
## ##         }

## ## # one of which is just not allowed
## ##     } else {
## ##         stop("Cannot download data from Single File and Size dataset Jointly")
## ##     }


## ##   }


## ## # --------------------------------------------------------------------------------------
## ## # SIC INDUSTRY
## ## # --------------------------------------------------------------------------------------
## ##     if(industry == "sic"){

## ##         if ( prod( !(data_cut %in% c(7,8,9,10,11,12,24,25)) ) ){       # no size

## ##             for (i_cut in 1:length(data_cut)){  # pad with zeroes
## ##                 if (data_cut[i_cut] < 10){ data_cut[i_cut] <- paste0("0", data_cut[i_cut]) }
## ##             }

## ##             for (year in seq(year_start, year_end)) {

## ##                 message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
## ##                 file_name <- download_qcew_data(target_year = year,
## ##                                                 industry = industry, frequency = frequency,
## ##                                                 path_data = paste0(path_data, subdir, "/"),
## ##                                                 url_wayback = url_wayback)

## ##                 df <- fread(paste0(path_data, subdir, "/", file_name) )

## ##                 dt_split <- df[ agglvl_code %in% data_cut ]

## ##                 dt_split[, old_industry_code := industry_code ]
## ##                 dt_split[, industry_code := gsub("[[:alpha:]]", "", str_sub(old_industry_code, 6, -1) ) ]
## ##                 dt_split[ is.na(as.numeric(industry_code)), sic := NA ]

## ##                 ## dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

## ##                 # cleaning up
## ##                 file.remove( paste0(path_data, subdir, "/", file_name) )
## ##                 message("")
## ##                 dt_res <- rbind(dt_res, dt_split, fill = T)

## ##             }

## ##         # ------------------------------------------------------------------------
## ##         # SIZE DATA: no frequency here either
## ##         } else if ( prod(data_cut %in% c(7,8,9,10,11,12,24,25)) ){

## ##             for (i_cut in 1:length(data_cut)){  # pad with zeroes
## ##                 if (data_cut[i_cut] < 10){ data_cut[i_cut] <- paste0("0", data_cut[i_cut]) }
## ##             }

## ##             for (year in seq(year_start, year_end)) {

## ##                 message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type. Size subdivision"))
## ##                 file_name <- download_qcew_size_data(target_year = year, industry,
## ##                                                      path_data = paste0(path_data, subdir, "/"),
## ##                                                      url_wayback = url_wayback)

## ##                 df <- fread( paste0(path_data, subdir, "/", file_name) )

## ##                 dt_split <- df[ agglvl_code %in% data_cut ]

## ##                 dt_split[, old_industry_code := industry_code ]
## ##                 dt_split[, industry_code := gsub("[[:alpha:]]", "", str_sub(old_industry_code, 6, -1) ) ]
## ##                 dt_split[ is.na(as.numeric(industry_code)), sic := NA ]

## ##                                         # cleaning up
## ##                 file.remove( paste0(path_data, subdir, "/", file_name) )
## ##                 message("")

## ##                 dt_res <- rbind(dt_res, dt_split, fill = T)

## ##             }
## ##         }
## ##     }

## ##     unlink(paste0(path_data, subdir), recursive = T) # erase the temp subdirectory

## ##     if (write == T){
## ##         write.csv( dt_res, row.names = F, paste0(path_data, "qcew_", data_cut, ".csv") )
## ##     }

## ##     return( dt_res )

## ## }












## ## #' Tidying the dataset for regression use (or merge)
## ## #'
## ## #' @param dt: input dataset from get_files_cut
## ## #' @param industry: download naics or sic data
## ## #' @param frequency: download either quarterly, monthly or all data
## ## #' @note returns a data.table file that is formatted according to tidy standard
## ## #'   typically this will be year x sub_year (quarter or month) x size x own_code x industry
## ## #'   the file can be aggregated as such
## ## #'   I do not download all the information (some location quotients and taxes are forgotten)
## ## #' @return data.table dt_tidy
## ## #' @examples
## ## #'   dt_tidy <- tidy_qcew(data_cut = 10,
## ## #'                        year_start = 1990, year_end =1993,
## ## #'                        path_data = "~/Downloads/", write = T)
## ## #' @export
## ## tidy_qwi <- function(
## ##   dt,
## ##   frequency = "all",
## ##   industry = "naics"
## ## ){

## ##   if (frequency %in% c("month", "all")){

## ##     dt_month <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
## ##                           month1_emplvl, month2_emplvl, month3_emplvl,
## ##                           area_fips, own_code, size_code, agglvl_code) ]
## ##     dt_month <- dt_month %>% gather(month, emplvl, month1_emplvl:month3_emplvl) %>% data.table
## ##     dt_month[, `:=`(month = as.numeric(gsub("[^\\d]+", "", month, perl=TRUE)) ) ]
## ##     dt_month[, month := (quarter-1)*3 + month ]
## ##     setorder(dt_month, agglvl_code, industry_code, year, month)

## ##     if (frequency == "month"){
## ##       dt_tidy <- dt_month
## ##     }

## ##   }

## ##   if (frequency %in% c("quarter", "all")){

## ##     if (industry == "naics"){

## ##       dt_quarter <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
## ##                               total_qtrly_wages, taxable_qtrly_wages, qtrly_contributions,
## ##                               avg_wkly_wage, qtrly_estabs, lq_qtrly_estabs, disclosure_code,
## ##                               area_fips, own_code, size_code, agglvl_code) ]


## ##     } else if (industry == "sic"){

## ##       dt_quarter <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
## ##                               total_qtrly_wages, taxable_qtrly_wages, qtrly_contributions,
## ##                               avg_wkly_wage, qtrly_estabs = qtrly_estabs_count,
## ##                               area_fips, own_code, size_code, agglvl_code) ]

## ##     }

## ##     setorder(dt_quarter, agglvl_code, industry_code, year, quarter)

## ##     if (frequency == "quarter"){

## ##        setorder(dt_quarter, own_code, area_fips, agglvl_code, industry_code, size_code, year, month)
## ##        dt_tidy <- dt_quarter

## ##     }

## ##   }

## ##   if (frequency == "all"){

## ##     dt_tidy <- merge(dt_month, dt_quarter, all.x = T,
## ##                      by = c("year", "quarter", "industry_code", "own_code", "area_fips", "size_code", "agglvl_code") )
## ##     setorder(dt_tidy, own_code, area_fips, agglvl_code, industry_code, size_code, year, month)

## ##   }

## ##   return( dt_tidy )

## ## }
















## ## #' Download QCEW dataset from directly from the BLS website
## ## #'
## ## #' @param target_year: year for which we want to download the data
## ## #' @param industry: download naics or sic data
## ## #' @param path_data: where does the download happen: default current directory + tmp
## ## #' @param frequency: download the quarterly files or the yearly files (default is quarterly)
## ## #' @param url_wayback: allows to specify the path in internet wayback machine that kept some of the archive
## ## #' @return file complete path. Downloads the file to the current directory and unzips it.
## ## download_qwi_data = function(
## ##   target_year,
## ##   state,
## ##   ## industry    = "naics",
## ##   path_data   = "./",
## ##   ## frequency   = "quarter",
## ##   ## url_wayback = "",
## ##   ## unzip       = T,
## ##   verbose     = F
## ## ){



## ## # ------------------------------------------------------------------------------
## ## # STATE LEVEL
## ## # debug
## ##     target_year = 2000
## ##     state = "MA"
## ##     demographics = "se"
## ##     firm  = "f"
## ##     geography = "gs"
## ##     industry = "n3"
## ##     ownership = "oslp"

## ## path_data = "~/Downloads/"


## ## # --- CREATE DIR TO DOWLOAD IN
## ##     subdir <- paste0("a",
## ##                      random::randomStrings(n=1, len=5, digits=TRUE, upperalpha=TRUE,
## ##                                            loweralpha=TRUE, unique=TRUE, check=TRUE))   # generate a random subdirectory to download the data
## ##     message(paste0("# -----------------------------------------------------\n",
## ##                    "# Creating temporary directory for all the downloads: '", path_data, subdir, "' "))
## ##     dir.create(paste0(path_data, subdir))



## ## # ------------------------------------------------------------------------------
## ## # STATE LEVEL


## ## # --- CREATE THE URL TO DOWNLOAD THE FILE
## ##     url_prefix <- "https://lehd.ces.census.gov/pub/"

## ##     url_final  <- paste0(url_prefix, tolower(state), "/latest_release/DVD-",
## ##                          demographics, "_", firm, "/")
## ##     zip_file_name  <- paste0("qwi_", tolower(state), "_", demographics, "_", firm, "_",
## ##                              geography, "_", industry, "_", ownership, "_u.csv.gz")
## ##     url_final
## ##     zip_file_name


## ## # --- DOWNLOAD IN PROGRESS
## ##     if (verbose == T){
## ##         message(paste0("# Downloading from url .... ", url_final))
## ##     }

## ##     url_final = paste0(url_final, zip_file_name)
## ##     download.file(url_final,
## ##                   paste0(path_data, subdir, "/", zip_file_name) )           # download file to path_data
## ##     if (unzip == T){
## ##         R.utils::gunzip(paste0(path_data, subdir, "/", zip_file_name) )              # extract the file in path_data
## ##     }

## ##     dt1 <- fread(paste0(path_data, subdir, "/", stringr::str_sub(zip_file_name, 1, -4)) )


## ##     dt1 %>% tab(seasonadj)
## ##     dt1 %>% tab(geo_level)
## ##     dt1 %>% tab(year)


## ## # ------------------------------------------------------------------------------
## ## # NATIONAL LEVEL



## ## # --- CREATE THE URL TO DOWNLOAD THE FILE
## ##     url_prefix <- "https://lehd.ces.census.gov/data/qwi/us/R2017Q1/"

## ##     url_final  <- paste0(url_prefix, tolower(state), "/DVD-",
## ##                          demographics, "_", firm, "/")
## ##     zip_file_name  <- paste0("qwi_", "", "_us_", demographics, "_", firm, "_",
## ##                              geography, "_", industry, "_", ownership, "_u.csv.gz")
## ##     url_final
## ##     zip_file_name


## ## # --- DOWNLOAD IN PROGRESS
## ##     if (verbose == T){
## ##         message(paste0("# Downloading from url .... ", url_final))
## ##     }

## ##     url_final = paste0(url_final, zip_file_name)
## ##     download.file(url_final,
## ##                   paste0(path_data, subdir, "/", zip_file_name) )           # download file to path_data
## ##     if (unzip == T){
## ##         R.utils::gunzip(paste0(path_data, subdir, "/", zip_file_name) )              # extract the file in path_data
## ##     }

## ##     dt1 <- fread(paste0(path_data, subdir, "/", stringr::str_sub(zip_file_name, 1, -4)) )


## ##     dt1 <- fread("~/Downloads/qwi_tmp/qwi_tmp.csv")
## ##     dt2 <- fread("~/Downloads/qwi_ma_sa_fa_gs_n4_op_u.csv")

## ##     dt1 %>% tab(seasonadj)
## ##     dt1 %>% tab(geo_level)

## ##     dt1 %>% tab(geography)
## ##     dt2 %>% tab(geography)
## ##     dt1[ geography == 25 ] %>% tab(geography)

## ##     dt1 %>% tab(year)
## ##     dt1[ geography == 25 ] %>% tab(year)
## ##     dt2 %>% tab(year)



## ##     dt1 %>% tab(quarter)



## ##     dt1 %>% tab(firmage)
## ##     dt2 %>% tab(firmage)

## ##     dt1 %>% tab(industry)
## ##     dt2 %>% tab(industry)












## } # end of download_qwi_data




## #    if (industry == "naics"){
## #        zip_file_name = paste0(toString(target_year), "_",
## #                               freq_string, "_singlefile.zip")
## #        dir_name      = paste0(url_prefix, toString(target_year), "/csv/")
## #    } else if (industry == "sic"){
## #        zip_file_name = paste0("sic_", toString(target_year), "_",
## #                               freq_string, "_singlefile.zip")
## #        dir_name      = paste0(url_prefix, toString(target_year), "/sic/csv/")
## #    }

