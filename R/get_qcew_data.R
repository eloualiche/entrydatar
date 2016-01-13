#' Group all the functions
#'
#' @note downloads data from the Quarterly Census for Employment and Wages
#'   program, for desired years, splitting data by the aggregation level codes
#'   and exporting them into separate files sorted by year and aggregation level
#' @note: we intend to have a single file for each aggregation level, but it is
#' more convenient to merge the individual files using an external command line
#' tool like cat
#'



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







#' Other code: loads data.table with option to write it for a given cut
#'
#' @param path_data: where do we store the data
#' @param year_start: start year for which we want data
#' @param year_end: end year for which we want data
#' @return data.table aggregate
#' @examples
#'   dt <- get_files_cut(data_cut = 10, year_start = 1990, year_end =1993, path_data = "~/Downloads/", write = T)
#' @export
get_files_cut = function(
  data_cut = 10,
  year_start = 1990,
  year_end = 2013,
  industry = "naics",
  path_data = "~/Downloads/",
  write = F
){

  dt_res <- data.table()

  if(industry == "naics"){

    if (data_cut <= 20 | data_cut >= 30){

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
        download_qcew_data(target_year = year, industry = industry, path_data = path_data)

        df <- fread(paste0(path_data,
                           toString(year), ".q1-q4.singlefile.csv"))

        dt_split <- split(df, df$agglvl_code)

        dt_split <- data.table(dt_split[ c(paste0(data_cut)) ][[1]])
        dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

        # cleaning up
        file.remove( paste0(path_data, year, ".q1-q4.singlefile.csv" ) )
        file.remove( paste0(path_data, year, "_qtrly_singlefile.zip" ) )
        message("")

      dt_res <- rbind(dt_res, dt_split, fill = T)

      }

    } else if (data_cut >= 20 & data_cut <= 30){

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
        download_qcew_size_data(target_year = year, industry = industry, path_data = path_data)

        df <- fread( paste0(path_data, toString(year), ".q1.by_size.csv") )
        dt_split <- split(df, df$agglvl_code)

        dt_split <- data.table(dt_split[ c(paste0(data_cut)) ][[1]])
        dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

        # cleaning up
        file.remove( paste0(path_data, year, ".q1-q4.singlefile.csv" ) )
        file.remove( paste0(path_data, year, "_qtrly_singlefile.zip" ) )
        message("")

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }
    }
  }

  if(industry == "sic"){

    if (!(data_cut %in% c(7,8,9,10,11,12,24,25)) ){

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
        download_qcew_data(target_year = year, industry = industry, path_data = path_data)

        df <- fread(paste0(path_data,
                           "sic.", toString(year), ".q1-q4.singlefile.csv"))

        dt_split <- split(df, df$agglvl_code)

        dt_split <- data.table(dt_split[ c(paste0(data_cut)) ][[1]])
        dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

        # cleaning up
        file.remove( paste0(path_data, "sic.", year, ".q1-q4.singlefile.csv" ) )
        file.remove( paste0(path_data, "sic_", year, "_qtrly_singlefile.zip" ) )
        message("")

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }

    } else if (data_cut %in% c(7,8,9,10,11,12,24,25)){

      for (year in seq(year_start, year_end)) {

        message(paste0("Processing data for year ", toString(year)," and ", industry, " industry type."))
        download_qcew_size_data(target_year = year, industry, path_data = path_data)

        df <- fread( paste0(path_data, toString(year), ".q1.by_size.csv") )
        dt_split <- split(df, df$agglvl_code)

        dt_split <- data.table(dt_split[ c(paste0(data_cut)) ][[1]])
        dt_split <- dt_split[, colnames(dt_split)[2:ncol(dt_split)] := lapply(.SD, as.numeric), .SDcols = 2:ncol(dt_split) ]

        # cleaning up
        file.remove( paste0(path_data, year, ".q1-q4.singlefile.csv" ) )
        file.remove( paste0(path_data, year, "_qtrly_singlefile.zip" ) )
        message("")

        dt_res <- rbind(dt_res, dt_split, fill = T)

      }
    }
  }


  if (write == T){
    write.csv( dt_res, row.names = F, paste0(path_data, "qcew_", data_cut, ".csv") )
  }

  return( dt_res )

}







#' Download QCEW dataset from directly from the BLS website
#'
#' @param target_year: year for which we want to download the data
#' @param path_data: where does the download happen: default current directory
#' @return NIL. Downloads the file to the current directory and unzips it.
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

} # end of download_data




#' Download QCEW dataset (size files 1st quarter) directly from the BLS website
#'
#' @param target_year: year for which we want to download the data
#' @param path_data: where does the download happen: default current directory
#' @return NIL. Downloads the file to the current directory and unzips it.
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
  }

  download.file(url,
                paste0(path_data, zip_file_name) )           # download file to path_data
  unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data

} # end of download_data
