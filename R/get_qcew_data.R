#' Group all the functions
#'
#' @note downloads data from the Quarterly Census for Employment and Wages
#'   program, for desired years, splitting data by the aggregation level codes
#'   and exporting them into separate files sorted by year and aggregation level
#' @note: we intend to have a single file for each aggregation level, but it is
#' more convenient to merge the individual files using an external command line
#' tool like cat
#'





#' Other code: loads data.table with option to write it for a given cut
#'
#' @param data_cut see vignette for a list of the cut
#' @param year_start start year for which we want data
#' @param year_end end year for which we want data
#' @param industry download naics or sic data
#' @param frequency download the quarterly files or the yearly files (default is quarterly)
#' @param path_data where do we store the data
#' @param subdir do we create a random dir
#' @param download if empty do download the file from the BLS website, if not use a local version with download as path
#' @param url_wayback allows to specify the path in internet wayback machine that kept some of the archive
#' @param write save it somewhere
#' @param verbose useful for looking all the downloads link (debugging mode)
#' @return data.table aggregate
#' @examples
#'   \dontrun{
#'   dt <- get_qcew_cut(data_cut = 10, year_start = 1990, year_end =1993,
#'                       path_data = "~/Downloads/", write = T)
#'   }
#' @export
get_qcew_cut <- function(
  data_cut      = 10,
  year_start    = 1990,
  year_end      = 2015,
  industry      = "naics",
  frequency     = "quarter",
  path_data     = "~/Downloads/tmp_data/",
  subdir        = T,
  download      = "",
  url_wayback   = "",
  write         = F,
  verbose       = F
){

  # For side-stepping checks in R
  agglvl_code <- old_industry_code <- industry_code <- sic <- NULL

  # Start of function
  dt_res <- data.table()

  if (subdir == T){
    subdir <- random::randomStrings(n=1, len=5, digits=TRUE, upperalpha=TRUE,
                                    loweralpha=TRUE, unique=TRUE, check=TRUE)   # generate a random subdirectory to download the data
    message(paste0("# -----------------------------------------------------\n",
                   "# Creating temporary directory for all the downloads: '", path_data, subdir, "' "))
    dir.create(paste0(path_data, subdir))
  } else {
    subdir <- ""
 }

  # ------------------------------------------------------------------------
  if(industry == "naics"){
    # NON SIZE DATA SAMPLE
    if ( prod(data_cut <= 20 | data_cut >= 30) ){          # make sure all the elements are of the same type
      for (year_iter in seq(year_start, year_end)) {
        message(paste0("\n# Processing data for year ", toString(year_iter)," and ",
                       industry, " industry type."))
        # If we do not download the file ... and read it directly from the BLS website
        if (download == ""){
          message("# Download in progress ... ")
          # read the file directly from the remote url
          file_name <- download_qcew_data(target_year = year_iter,
                                          industry = industry, frequency = frequency,
                                          path_data = paste0(path_data, subdir, "/"),
                                          url_wayback = url_wayback,
                                          download = F, verbose = verbose)
  # df <- fread(paste0(path_data, subdir, "/", file_name) ) #, colClasses = c(disclosure_code = "character") )
          # read the zip file directly
          df <- fread.zip.url(file_name)

          } else {
            message("# Read file locally ... ")
            system( paste0("tar -xvzf ", "'", download, "/",
                           year_iter, "_qtrly_singlefile.zip' ", "-C ", path_data, subdir ) )
            df <- fread(paste0(path_data, subdir, "/", paste0(year_iter, ".q1-q4.singlefile.csv")) )
            #, colClasses = c(disclosure_code = "character") )
          }
          dt_split <- df[ agglvl_code %in% data_cut ]
          vec_tmp <- dt_split$disclosure_code          # only character
          dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), 
                               .SDcols = 2:ncol(dt_split) ]
          dt_split$disclosure_code <- vec_tmp
          # this clean up is not necessary to keep disclosure codes intact

          # cleaning up
          # unlink(paste0(path_data, subdir), recursive = T)
          message("")
          if (download == ""){
              file.remove( paste0(path_data, subdir, "/", file_name) )
          } else {
              system(paste0("rm ", path_data, subdir, "/*.csv"))
          }

          dt_res <- rbind(dt_res, dt_split, fill = T)
      }


   # ------------------------------------------------------------------------
   # SIZE DATA: downloading only quarter version for now (ignore frequency)
    } else if ( prod(data_cut >= 20 & data_cut < 30) ){
        for (year in seq(year_start, year_end)) {
            message(paste0("Processing data for year ", toString(year)," and ", 
                           industry, " industry type. Size subdivision"))
            file_name <- download_qcew_size_data(target_year = year,
                                                 industry = industry,
                                                 path_data = paste0(path_data, subdir, "/"),
                                                 url_wayback = url_wayback)
            df <- fread( paste0(path_data, subdir, "/", file_name) )
            dt_split <- df[ agglvl_code %in% data_cut ]
            dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), 
                                 .SDcols = 2:ncol(dt_split) ]
            # setnames(dt_split, c("qtrly_estabs_count", "lq_qtrly_estabs_count"),
            # c("qtrly_estabs", "lq_qtrly_estabs") )
            # cleaning up
            message("")
            file.remove( paste0(path_data, subdir, "/", file_name) )
            dt_res <- rbind(dt_res, dt_split, fill = T)
        }
        # one of which is just not allowed
    } else {
        stop("Cannot download data from Single File and Size dataset Jointly")
    }
  }     # end of flow for DOWNLOADING NAICS
  # --------------------------------------------------------------------------------------
  
# --------------------------------------------------------------------------------------
# SIC INDUSTRY
# --------------------------------------------------------------------------------------
  if(industry == "sic"){
    if ( prod( !(data_cut %in% c(7,8,9,10,11,12,24,25)) ) ){       # no size
      for (i_cut in 1:length(data_cut)){  # pad with zeroes
        if (data_cut[i_cut] < 10){ data_cut[i_cut] <- paste0("0", data_cut[i_cut]) }
      }
      for (year in seq(year_start, year_end)) {
        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
        file_name <- download_qcew_data(target_year = year,
                                        industry = industry, frequency = frequency,
                                        path_data = paste0(path_data, subdir, "/"),
                                        url_wayback = url_wayback)
        df <- fread(paste0(path_data, subdir, "/", file_name) )
        dt_split <- df[ agglvl_code %in% data_cut ]
        dt_split[, old_industry_code := industry_code ]
        dt_split[, industry_code := gsub("[[:alpha:]]", "", str_sub(old_industry_code, 6, -1) ) ]
        dt_split[ is.na(as.numeric(industry_code)), sic := NA ]
        ## dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), 
        ##                        .SDcols = 2:ncol(dt_split) ]
        # cleaning up
        file.remove( paste0(path_data, subdir, "/", file_name) )
        message("")
        dt_res <- rbind(dt_res, dt_split, fill = T)
      } # end of loop over the years
      
    } else if ( prod(data_cut %in% c(7,8,9,10,11,12,24,25)) ){   # SIZE DATA: no frequency here either
      for (i_cut in 1:length(data_cut)){  # pad with zeroes
        if (data_cut[i_cut] < 10){ data_cut[i_cut] <- paste0("0", data_cut[i_cut]) }
      }
      for (year in seq(year_start, year_end)) {
        message(paste0("Processing data for year ", toString(year)," and ", 
                       industry, " industry type. Size subdivision"))
        file_name <- download_qcew_size_data(target_year = year, industry,
                                             path_data = paste0(path_data, subdir, "/"),
                                             url_wayback = url_wayback)
        df <- fread( paste0(path_data, subdir, "/", file_name) )
        dt_split <- df[ agglvl_code %in% data_cut ]

        dt_split[, old_industry_code := industry_code ]
        dt_split[, industry_code := gsub("[[:alpha:]]", "", str_sub(old_industry_code, 6, -1) ) ]
        dt_split[ is.na(as.numeric(industry_code)), sic := NA ]
        # cleaning up
        file.remove( paste0(path_data, subdir, "/", file_name) )
        message("")
        dt_res <- rbind(dt_res, dt_split, fill = T)
      } # end of loop over the years
    }   # end of loop for size split data   
  }
  # cleaning up
  unlink(paste0(path_data, subdir), recursive = T) # erase the temp subdirectory
  if (write == T){
    data.table::fwrite( dt_res, row.names = F, paste0(path_data, "qcew_", data_cut, ".csv") )
  }

  return( dt_res )

} # end of get_qcew_cut
# --------------------------------------------------------------------------------------



#' Tidying the dataset for regression use (or merge)
#'
#' @param dt input dataset from get_qcew_cut
#' @param industry download naics or sic data
#' @param frequency download either quarterly, monthly or all data
#' @note returns a data.table file that is formatted according to tidy standard
#'   typically this will be year x sub_year (quarter or month) x size x own_code x industry
#'   the file can be aggregated as such
#'   I do not download all the information (some location quotients and taxes are forgotten)
#' @return data.table dt_tidy
#' @examples
#'   \dontrun{
#'   dt_tidy <- tidy_qcew(data_cut = 10,
#'                        year_start = 1990, year_end =1993,
#'                        path_data = "~/Downloads/", write = T)
#'   }
#' @export
tidy_qcew <- function(
  dt,
  frequency = "all",
  industry = "naics"
){

  # side step checks in R
  qtr <-avg_wkly_wage <- qtrly_estabs <- lq_qtrly_estabs <- disclosure_code <- qtrly_estabs_count <- NULL
  industry_code <- month1_emplvl <- month2_emplvl <- month3_emplvl <- area_fips <- NULL
  own_code <- size_code <- agglvl_code <- emplvl <- total_qtrly_wages <- taxable_qtrly_wages <- qtrly_contributions <- NULL

  # official function starts here
  if (frequency %in% c("month", "all")){

    dt_month <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
                       month1_emplvl, month2_emplvl, month3_emplvl,
                       area_fips, own_code, size_code, agglvl_code) ]
    dt_month <- dt_month %>% tidyr::gather(month, emplvl, month1_emplvl:month3_emplvl) %>% data.table
    dt_month[, `:=`(month = as.numeric(gsub("[^\\d]+", "", month, perl=TRUE)) ) ]
    dt_month[, month := (quarter-1)*3 + month ]
    setorder(dt_month, agglvl_code, industry_code, year, month)

    if (frequency == "month"){
      dt_tidy <- dt_month
    }

  }

  if (frequency %in% c("quarter", "all")){

    if (industry == "naics"){

      dt_quarter <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
                           total_qtrly_wages, taxable_qtrly_wages, qtrly_contributions,
                           avg_wkly_wage, qtrly_estabs, lq_qtrly_estabs, disclosure_code,
                           area_fips, own_code, size_code, agglvl_code) ]


    } else if (industry == "sic"){

      dt_quarter <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
                              total_qtrly_wages, taxable_qtrly_wages, qtrly_contributions,
                              avg_wkly_wage, qtrly_estabs = qtrly_estabs_count,
                              area_fips, own_code, size_code, agglvl_code) ]

    }

    setorder(dt_quarter, agglvl_code, industry_code, year, quarter)

    if (frequency == "quarter"){

       setorder(dt_quarter, own_code, area_fips, agglvl_code, industry_code, size_code, year, month)
       dt_tidy <- dt_quarter

    }

  }

  if (frequency == "all"){

    dt_tidy <- merge(dt_month, dt_quarter, all.x = T,
                     by = c("year", "quarter", "industry_code", "own_code", "area_fips", "size_code", "agglvl_code") )
    setorder(dt_tidy, own_code, area_fips, agglvl_code, industry_code, size_code, year, month)

  }

  return( dt_tidy )

}









#' Tidying the dataset for regression use (or merge): operate year by year to keep memory to manageable levels.
#'
#' @param dt        input dataset from get_qcew_cut
#' @param industry  download naics or sic data
#' @param frequency download either quarterly, monthly or all data
#' @param verbose   do we print the years to see how fast we are going
#' @note returns a data.table file that is formatted according to tidy standard
#'   typically this will be year x sub_year (quarter or month) x size x own_code x industry
#'   the file can be aggregated as such
#'   I do not download all the information (some location quotients and taxes are forgotten)
#' @return data.table dt_res
#' @examples
#'   \dontrun{
#'   dt_tidy <- tidy_qcew_year(dt, frequency = "all", industry = "naics")
#'   }
#' @export
tidy_qcew_year <- function(
  dt,
  frequency = "all",
  industry  = "naics",
  verbose   = TRUE
){

  year_list <- as.vector(unique(dt$year))
  dt_res <- data.table()

  for (i_year in 1:length(year_list) ){
    if (verbose == TRUE){
      message("Processing year ... ", i_year)
    }
    sub_year <- year_list[i_year]
    dt_tmp <- dt[ year == sub_year ]
    dt_tmp <- tidy_qcew(dt_tmp,
                frequency = frequency, industry = industry)
    dt_res <- rbind(dt_res, dt_tmp)
  }

  return( dt_res )
} # end of tidy_qcew_year










#' Export the downloaded table into a csv file.
#'
#' @param year  filename for .csv file. Note that you need to pass in the
#'   correct year here, since the function has no idea of what the actual year
#'   corresponding to this data is
#' @param named_df  data frame with name
#' @param path_data where does the download happen: default current directory
#' @note generates the appropriate directory if it does not already exist.
#' @note our data does not have any headers; this simplifies the process of
#'   joining all the csv files with cat or similar command line tools so that we
#'   have a single file across all aggregation level codes.
#' @return NIL. Exports csv file "./singlefile/$agglvl_code/$year.csv"
export_named_df = function(
  path_data = "./",
  year,
  named_df
){

  agglvl_code = names(named_df)[1]
  message(paste0("Processing aggregation level code ", agglvl_code))

  destination_folder = file.path(paste0(path_data, "singlefile/", agglvl_code))

  if (!file.exists(destination_folder)){
    dir.create(destination_folder, recursive=TRUE)
  }

  destination_file = file.path(destination_folder, paste0(toString(year), ".csv"))
  file.create(destination_file)

  data.frame(named_df) %>%
    utils::write.table(file = destination_file, append=TRUE, row.names=FALSE, col.names=FALSE , sep=",")

}













#' Export a dataset we are directly reading.
#'
#' @param path_data    where does the download happen: default current directory
#' @param target_year  year for which we want to export the data
#' @note assumes that file is at "./$target_year.q1_q4.singlefile.csv". This is the expected
#'   path and file name when the csv file is extracted from the zip file with no renaming.
#' @return NIL. Exports the data using the helper function export_named_df.
export_all_data = function (
  target_year,
  path_data = "./"
){

  df <- fread(paste0(path_data,
                     toString(target_year), ".q1-q4.singlefile.csv"))
  df_split <- split(df, df$agglvl_code)

  for (i in seq(length(df_split))){
    export_named_df(path_data, target_year, df_split[i])
  }

}


#' Master code: for selected years, download and export the data.
#'
#' @param path_data where do we store the data
#' @param year_start start year for which we want data
#' @param year_end end year for which we want data
#' @param industry download naics or sic data
#' @return NIL. Gets data for all years in range, splits the data, and then
#'   exports it into the appropriate files
#' @export
get_files_master = function (
  path_data = "~/Downloads/",
  year_start = 1990,
  year_end = 2013,
  industry = "naics"
  ){

  for (year in seq(year_start, year_end)) {

    message(paste0("Processing data for year ", toString(year)))
    download_qcew_data(target_year = year, path_data = path_data)

    # splitting the data
    export_all_data(target_year = year, path_data = path_data)

    # cleaning up
    file.remove( paste0(path_data, year, ".q1-q4.singlefile.csv" ) )
    file.remove( paste0(path_data, year, "_qtrly_singlefile.zip" ) )
    message("")

  }

}








#' Download QCEW dataset from directly from the BLS website
#'
#' @param target_year year for which we want to download the data
#' @param industry download naics or sic data
#' @param path_data where does the download happen: default current directory + tmp
#' @param frequency download the quarterly files or the yearly files (default is quarterly)
#' @param url_wayback allows to specify the path in internet wayback machine that kept some of the archive
#' @param unzip unzip the file
#' @param download default is TRUE, FALSE only returns the url
#' @param verbose how does the function output intermediate stages
#' @return file complete path. Downloads the file to the current directory and unzips it.
download_qcew_data = function(
  target_year,
  industry    = "naics",
  path_data   = "./",
  frequency   = "quarter",
  url_wayback = "",
  unzip       = T,
  download    = T,
  verbose     = F
){


    if (frequency %in% c("quarter", "Q")){
        freq_string = "qtrly"
    } else if (frequency %in% c("year", "Y")){
        freq_string = "annual"
    } else {
        stop(paste0("Wrong frequency input .... ", frequency))
    }

    url_prefix <- "http://data.bls.gov/cew/data/files/"
    if (url_wayback != ""){
        url_prefix = url_wayback
        url_prefix <- paste0("https://web.archive.org/web/20141101135821/", "http://www.bls.gov/cew/data/files/")
        # note that this pulls from the old server www.bls.gov instead of data.bls.gov
        # 2011/csv/2011_qtrly_singlefile.zip"
    }


    if (industry == "naics"){
        zip_file_name = paste0(toString(target_year), "_",
                               freq_string, "_singlefile.zip")
        dir_name      = paste0(url_prefix, toString(target_year), "/csv/")
    } else if (industry == "sic"){
        zip_file_name = paste0("sic_", toString(target_year), "_",
                               freq_string, "_singlefile.zip")
        dir_name      = paste0(url_prefix, toString(target_year), "/sic/csv/")
    }

    if (verbose == T){
        message(paste0("# Downloading from url .... ", url_prefix))
    }
    url = paste0(dir_name, zip_file_name)

    # return file or the url:
    if (download == F){
      return(url)
    } else if (download == T){
        download.file(url,
                    paste0(path_data, zip_file_name) )           # download file to path_data
        if (unzip == T){
          unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data
        }
    # output is list of files in directory
      read_list <- list.files( paste0(path_data) )
      read_list <- read_list[grep("\\.csv$", read_list)]
      return(read_list)
    }

} # end of download_qcew_data














#' Download QCEW dataset (size files 1st quarter) directly from the BLS website
#'
#' @param target_year year for which we want to download the data
#' @param path_data   where does the download happen: default current directory
#' @param industry    download naics or sic data
#' @param url_wayback allows to specify the path in internet wayback machine that kept some of the archive
#' @param unzip       default is True, False is useful if you are just downloading the data
#' @return read_list  String with names of downloaded files
#' @note Downloads the file to the current directory and unzips it.
download_qcew_size_data = function(
  target_year,
  industry    = "naics",
  path_data   = "./",
  url_wayback = "",
  unzip       = T
){

  url_prefix <- "http://data.bls.gov/cew/data/files/"
  if (url_wayback != ""){
    url_wayback <- (gsub("[^\\d]+", "", url_wayback, perl=TRUE))  # extract the date from the wayback call (so we can also just input a date)
    url_wayback <- paste0("https://web.archive.org/web/", url_wayback, "/")
    url_prefix <- paste0(url_wayback, "http://www.bls.gov/cew/data/files/")
  }

  if (industry == "naics"){
    zip_file_name = paste0(toString(target_year), "_q1_by_size.zip")

    url = paste0(
      url_prefix,
      toString(target_year),
      "/csv/",
      zip_file_name)

    download.file(url,
                  paste0(path_data, zip_file_name) )           # download file to path_data
    if (unzip == T){
        unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data
    }

  } else if (industry == "sic"){
    if (target_year < 1997 | target_year > 2000){
      warning("No size files for sic outside of 1997-2000 period.")
    }

    zip_file_name = paste0("sic_", toString(target_year), "_q1_by_size.zip")

    # http://www.bls.gov/cew/data/files/2000/sic/csv/sic_2000_q1_by_size.zip
    url <- paste0(
      url_prefix,
      toString(target_year),
      "/sic/csv/",
      zip_file_name)

    download.file(url,
                  paste0(path_data, zip_file_name))
    if (unzip == T){
        unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data
    }

  }

 # output is list of files in directory
 read_list <- list.files( paste0(path_data) )
 read_list <- read_list[grep("\\.csv$", read_list)]

 return(read_list)

} # end of download_qcew_size_data




#' Other code: read zipped url, copied from https://stackoverflow.com/a/24586478
#'
#' @param url see vignette for a list of the cut
#' @param filename for multiple files in the archive
#' @param FUN default to fread from data.table but you could use anything
#' @return data.table of the remote file
#' @examples
#'   \dontrun{
#'   dt <- fread.zip.url(http://data.bls.gov/cew/data/files/2000/csv/2000_qtrly_singlefile.zip)
#'   }
fread.zip.url <- function(url, filename = NULL, FUN = fread, ...) {
  zipfile <- tempfile()
  download.file(url = url, destfile = zipfile, quiet = TRUE)
  zipdir <- tempfile()
  dir.create(zipdir)
  unzip(zipfile, exdir = zipdir) # files="" so extract all
  files <- list.files(zipdir)
  if (is.null(filename)) {
    if (length(files) == 1) {
      filename <- files
    } else {
      stop("multiple files in zip, but no filename specified: ", paste(files, collapse = ", "))
    }
  } else { # filename specified
    stopifnot(length(filename) ==1)
    stopifnot(filename %in% files)
  }
  file <- paste(zipdir, files[1], sep="/")
  do.call(FUN, args = c(list(file.path(zipdir, filename)), list(...)))
} # end of fread.zip.url
