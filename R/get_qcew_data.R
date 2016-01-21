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
#' @param path_data: where do we store the data
#' @param year_start: start year for which we want data
#' @param year_end: end year for which we want data
#' @param industry: download naics or sic data
#' @param write: save it somewhere
#' @return data.table aggregate
#' @examples
#'   dt <- get_files_cut(data_cut = 10, year_start = 1990, year_end =1993,
#'                       path_data = "~/Downloads/", write = T)
#' @export
get_files_cut = function(
  data_cut = 10,
  year_start = 1990,
  year_end = 2013,
  industry = "naics",
  path_data = "~/Desktop/tmp_data/",
  write = F
){

  dt_res <- data.table()

  subdir <- randomStrings(n=1, len=5, digits=TRUE, upperalpha=TRUE,
                          loweralpha=TRUE, unique=TRUE, check=TRUE)   # generate a random subdirectory to download the data
  dir.create(paste0(path_data, subdir))
  message(paste0("Creating temporary directory: '", path_data, subdir, "' "))

  if(industry == "naics"){

    # NON SIZE DATA SAMPLE
    if ( prod(data_cut <= 20 | data_cut >= 30) ){          # make sure all the elements are of the same type

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))

        file_name <- download_qcew_data(target_year = year, industry = industry,
                                        path_data = paste0(path_data, subdir, "/") )
        df <- fread(paste0(path_data, subdir, "/", file_name) )

        dt_split <- df[ agglvl_code %in% data_cut ]
        dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

        # cleaning up
        # unlink(paste0(path_data, subdir), recursive = T)
        message("")
        file.remove( paste0(path_data, subdir, "/", file_name) )

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }

    # SIZE DATA
    } else if ( prod(data_cut >= 20 & data_cut <= 30) ){

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type. Size subdivision"))

        file_name <- download_qcew_size_data(target_year = year, industry = industry,
                                             path_data = paste0(path_data, subdir, "/") )

        df <- fread( paste0(path_data, subdir, "/", file_name) )

        dt_split <- df[ agglvl_code %in% data_cut ]

        dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]
        setnames(dt_split, c("qtrly_estabs_count", "lq_qtrly_estabs_count"),
                           c("qtrly_estabs", "lq_qtrly_estabs") )

        # cleaning up
        message("")
        file.remove( paste0(path_data, subdir, "/", file_name) )

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }

    # one of which is just not allowed
    } else {

        stop("Cannot download data from Single File and Size dataset Jointly")

    }


  }

  # SIC INDUSTRY
  if(industry == "sic"){

    if ( prod( !(data_cut %in% c(7,8,9,10,11,12,24,25)) ) ){       # no size

      for (i_cut in 1:length(data_cut)){  # pad with zeroes
        if (data_cut[i_cut] < 10){ data_cut[i_cut] <- paste0("0", data_cut[i_cut]) }
      }

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
        file_name <- download_qcew_data(target_year = year, industry = industry,
                                        path_data = paste0(path_data, subdir, "/") )

        df <- fread(paste0(path_data, subdir, "/", file_name) )

        dt_split <- df[ agglvl_code %in% data_cut ]

        dt_split[, old_industry_code := industry_code ]
        dt_split[, industry_code := gsub("[[:alpha:]]", "", str_sub(old_industry_code, 6, -1) ) ]
        dt_split[ is.na(as.numeric(industry_code)), sic := NA ]

        ## dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

        # cleaning up
        file.remove( paste0(path_data, subdir, "/", file_name) )
        message("")

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }

    # SIZE DATA
    } else if ( prod(data_cut %in% c(7,8,9,10,11,12,24,25)) ){

      for (i_cut in 1:length(data_cut)){  # pad with zeroes
        if (data_cut[i_cut] < 10){ data_cut[i_cut] <- paste0("0", data_cut[i_cut]) }
      }

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type. Size subdivision"))
        file_name <- download_qcew_size_data(target_year = year, industry,
                                             path_data = paste0(path_data, subdir, "/") )

        df <- fread( paste0(path_data, subdir, "/", file_name) )

        dt_split <- df[ agglvl_code %in% data_cut ]

        dt_split[, old_industry_code := industry_code ]
        dt_split[, industry_code := gsub("[[:alpha:]]", "", str_sub(old_industry_code, 6, -1) ) ]
        dt_split[ is.na(as.numeric(industry_code)), sic := NA ]

        # cleaning up
        file.remove( paste0(path_data, subdir, "/", file_name) )
        message("")

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }
    }
  }


  unlink(paste0(path_data, subdir), recursive = T) # erase the temp subdirectory

  if (write == T){
    write.csv( dt_res, row.names = F, paste0(path_data, "qcew_", data_cut, ".csv") )
  }

  return( dt_res )

}


#' Tidying the dataset for regression use (or merge)
#'
#' @param dt: input dataset from get_files_cut
#' @param industry: download naics or sic data
#' @param frequency: download either quarterly, monthly or all data
#' @note returns a data.table file that is formatted according to tidy standard
#'   typically this will be year x sub_year (quarter or month) x size x own_code x industry
#'   the file can be aggregated as such
#'   I do not download all the information (some location quotients and taxes are forgotten)
#' @return data.table dt_tidy
#' @examples
#'   dt_tidy <- tidy_qcew(data_cut = 10,
#'                        year_start = 1990, year_end =1993,
#'                        path_data = "~/Downloads/", write = T)
#' @export
tidy_qcew <- function(
  dt,
  frequency = "all",
  industry = "naics"
){

  if (frequency %in% c("month", "all")){

    dt_month <- dt[, list(year, quarter = as.numeric(qtr), industry_code,
                          month1_emplvl, month2_emplvl, month3_emplvl,
                          area_fips, own_code, size_code, agglvl_code) ]
    dt_month <- dt_month %>% gather(month, emplvl, month1_emplvl:month3_emplvl) %>% data.table
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
                              avg_wkly_wage, qtrly_estabs, lq_qtrly_estabs,
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
#' @param dt: input dataset from get_files_cut
#' @param industry: download naics or sic data
#' @param frequency: download either quarterly, monthly or all data
#' @note returns a data.table file that is formatted according to tidy standard
#'   typically this will be year x sub_year (quarter or month) x size x own_code x industry
#'   the file can be aggregated as such
#'   I do not download all the information (some location quotients and taxes are forgotten)
#' @return data.table dt_res
#' @examples
#'   dt_tidy <- tidy_qcew_year(dt, frequency = "all", industry = "naics")
#' @export
tidy_qcew_year <- function(
  dt,
  frequency = "all",
  industry = "naics"
){

  year_list <- as.vector(unique(dt$year))
  dt_res <- data.table()

  for (i_year in 1:length(year_list) ){

    sub_year <- year_list[i_year]

    dt_tmp <- dt[ year == sub_year ]

    dt_tmp <- tidy_qcew(dt_tmp,
                frequency = frequency, industry = industry)

    dt_res <- rbind(dt_res, dt_tmp)

  }

  return( dt_res )

}





#' Export the downloaded table into a csv file.
#'
#' @param year: filename for .csv file. Note that you need to pass in the
#'   correct year here, since the function has no idea of what the actual year
#'   corresponding to this data is
#' @param named_df: data frame with name
#' @param path_data: where does the download happen: default current directory
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
    write.table(file = destination_file, append=TRUE, row.names=FALSE, col.names=FALSE , sep=",")

}




#' Export a dataset we are directly reading.
#'
#' @param path_data: where does the download happen: default current directory
#' @param target_year: year for which we want to export the data
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
#' @param path_data: where do we store the data
#' @param year_start: start year for which we want data
#' @param year_end: end year for which we want data
#' @param industry: download naics or sic data
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
    download_data(target_year = year, path_data = path_data)

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
#' @param target_year: year for which we want to download the data
#' @param path_data: where does the download happen: default current directory + tmp
#' @param industry: download naics or sic data
#' @return file complete path. Downloads the file to the current directory and unzips it.
download_qcew_data = function(
  target_year,
  industry = "naics",
  path_data = "./"
){

  if (industry == "naics"){
    zip_file_name = paste0(toString(target_year), "_qtrly_singlefile.zip")
    dir_name      = paste0("http://www.bls.gov/cew/data/files/", toString(target_year), "/csv/")
  } else if (industry == "sic"){
    zip_file_name = paste0("sic_", toString(target_year), "_qtrly_singlefile.zip")
    dir_name      = paste0("http://www.bls.gov/cew/data/files/", toString(target_year), "/sic/csv/")
  }

  url = paste0(dir_name, zip_file_name)

  download.file(url,
                paste0(path_data, zip_file_name) )           # download file to path_data
  unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data

  # output is list of files in directory
  read_list <- list.files( paste0(path_data) )
  read_list <- read_list[grep("\\.csv$", read_list)]

  return(read_list)

} # end of download_qcew




#' Download QCEW dataset (size files 1st quarter) directly from the BLS website
#'
#' @param target_year: year for which we want to download the data
#' @param path_data: where does the download happen: default current directory
#' @param industry: download naics or sic data
#' @return read_list: String with names of downloaded files
#' @note Downloads the file to the current directory and unzips it.
download_qcew_size_data = function(
  target_year,
  industry = "naics",
  path_data = "./"
){

  if (industry == "naics"){
    zip_file_name = paste0(toString(target_year), "_q1_by_size.zip")

    url = paste0(
      "http://www.bls.gov/cew/data/files/",
      toString(target_year),
      "/csv/",
      zip_file_name)

    download.file(url,
                  paste0(path_data, zip_file_name) )           # download file to path_data
    unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data

  } else if (industry == "sic"){

    if (target_year < 1997 | target_year > 2000){
      warning("No size files for sic outside of 1997-2000 period.")
    }

    zip_file_name = paste0("sic_", toString(target_year), "_q1_by_size.zip")

    # http://www.bls.gov/cew/data/files/2000/sic/csv/sic_2000_q1_by_size.zip
    url <- paste0(
      "http://www.bls.gov/cew/data/files/",
      toString(target_year),
      "/sic/csv/",
      zip_file_name)

    download.file(url,
                  paste0(path_data, zip_file_name))
    unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data

  }

 # output is list of files in directory
 read_list <- list.files( paste0(path_data) )
 read_list <- read_list[grep("\\.csv$", read_list)]

 return(read_list)

} # end of download_qcew_size_data
