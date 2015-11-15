#' Group all the functions
#'
#' @note downloads data from the Quarterly Census for Employment and Wages
#'   program, for desired years, splitting data by the aggregation level codes
#'   and exporting them into separate files sorted by year and aggregation level
#' @note: we intend to have a single file for each aggregation level, but it is
#' more convenient to merge the individual files using an external command line
#' tool like cat

devtools::use_package("dplyr")
devtools::use_package("plyr")
devtools::use_package("data.table")
devtools::use_package("functional")
devtools::use_package("bit64")

#' Download QCEW dataset from directly from the BLS website
#'
#' @param target_year: year for which we want to download the data
#' @return NIL. Downloads the file to the current directory and unzips it.
download_data = function (target_year)
  {
  zip_file_name = paste0(toString(target_year), "_qtrly_singlefile.zip")

  url = paste0(
    "http://www.bls.gov/cew/data/files/",
    toString(target_year),
    "/csv/",
    zip_file_name)
  download.file(url, zip_file_name)
  unzip(zip_file_name)
}



#' Export the downloaded table into a csv file.
#'
#' @param year: filename for .csv file. Note that you need to pass in the
#'   correct year here, since the function has no idea of what the actual year
#'   corresponding to this data is
#' @param named_df: data frame with name
#' @note generates the appropriate directory if it does not already exist.
#' @note our data does not have any headers; this simplifies the process of
#'   joining all the csv files with cat or similar command line tools so that we
#'   have a single file across all aggregation level codes.
#' @return NIL. Exports csv file "./singlefile/$agglvl_code/$year.csv"
export_named_df = function (year, named_df)
  {
  agglvl_code = names(named_df)[1]
  message(paste0("Processing aggregation level code ", agglvl_code))
  destination_folder = file.path("singlefile", agglvl_code)
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
#' @param target_year: year for which we want to export the data
#' @note assumes that file is at "./$target_year.q1_q4.singlefile.csv". This is the expected
#'   path and file name when the csv file is extracted from the zip file with no renaming.
#' @return NIL. Exports the data using the helper function export_named_df.
export_all_data = function (target_year)
{
  df = fread(paste0(toString(target_year), ".q1-q4.singlefile.csv"))
  df_split = split(df, df$agglvl_code)
  for (i in seq(length(df_split))){
    export_named_df(target_year, df_split[i])
  }
}


#' Master code: for selected years, download and export the data.
#'
#' @param year_start: start year for which we want data
#' @param year_end: end year for which we want data
#' @return NIL. Gets data for all years in range, splits the data, and then
#'   exports it into the appropriate files
#' @export
get_files_master = function (
  year_start = 1990,
  year_end = 2013
){
  for (year in seq(year_start, year_end)) {
    message(paste0("Processing data for year ", toString(year)))
    download_data(year)
    export_all_data(year)
    message("")
  }
}
