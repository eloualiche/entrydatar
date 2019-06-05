# Group all the functions

#' Clean the CBP
#'
#' @note Tidy up the CBP data into year state county industry dataset
#' @param dt_raw    data we start with.
#' @param industry   which level industries should be included (vector, NULL for all)
#' @param year_start year starting data (>=1986)
#' @param year_end   year ending data (<=2013)
#' @return data.table
#' @export
tidy_cbp <- function(
  dt_raw = NULL,
  industry   = c(2,3,4),
  year_start = 1996,
  year_end   = 2013
){

  if ( is.null(dt_raw)){
    dt_raw <- download_all_cbp(year_start, year_end)
  }

  dt_res <- copy(dt_raw)

  return(dt_res)

}


#' Download the CBP
#'
#' @note downloads data from the County Business Pattern
#'   for desired years, splitting data by the aggregation level codes
#'   the docs for the CBP is available at the following:
#'   http://www.census.gov/econ/cbp/download/full_layout/County_Layout_SIC.txt
#' @param year_start year starting data download
#' @param year_end year ending data download
#' @param aggregation_level which data type to download
#' @param path_data where does the download happen: default current directory
#' @return data.table
#' @export
download_all_cbp <- function(
  year_start        = 1996,
  year_end          = 2013,
  aggregation_level = "county",
  path_data         = "~/Downloads/"
){

  dt_res <- data.table()

  for (year in seq(year_start, year_end)){

    message(paste0("Downloading and processing year: ", year))
    dt_year <- download_cbp_data(target_year = year, path_data = path_data, aggregation_level = aggregation_level)
    dt_year[, year := year ]
    dt_res  <- rbind(dt_res, dt_year, fill = T)

  }

  return(dt_res)

}



#' Download one year of county business pattern dataset
#'
#' @param target_year year for which we want to download the data
#' @param aggregation_level which data cut to download
#' @param path_data where does the download happen: default current directory
#' @param download_method use wget or curl (default wget seems to work slightly better)
#' @return data.table
download_cbp_data <- function(
  target_year,
  aggregation_level = "county",
  path_data = "~/Downloads/",
  download_method = "wget"
){

  aggregation_level <- tolower(aggregation_level)

  #if (target_year >= 2002){
  #  path1 <- paste0("econ", target_year, "/")
  #} else {
  #  path1 <- "Econ2001_And_Earlier/"
  #}
  # path2 <- paste0("CBP_CSV/")

  if (aggregation_level == "county"){
    suffix = "co"
  } else if (aggregation_level == "us"){
    suffix = "us"
  } else if (aggregation_level == "state"){
    suffix = "st"
  } else if (aggregation_level == "msa"){
    suffix = "msa"
    if (target_year < 1993){
      warning("No MSA file before 1993")
      return( data.table() )
    }
  } else {
    stop(paste0("Aggregation level not known: ", aggregation_level, " ??"))
  }

  url_prefix    <- "http://www2.census.gov/programs-surveys/cbp/datasets/"
  partial_url   <- paste0(url_prefix, target_year, "/")
  zip_file_name <- paste0("cbp", str_sub(target_year, 3, 4), suffix, ".zip")
  file_name     <- paste0("Cbp", str_sub(target_year, 3, 4), suffix, ".txt")

  if (aggregation_level == "us" & target_year <= 2007){    # national case is not zipped before 2007
    url <- paste0(partial_url, file_name)
    utils::download.file(url,
                  paste0(path_data, file_name),
                  method = download_method)
    dt_res <- fread(paste0(path_data, file_name))
  } else {
    url <- paste0(partial_url, zip_file_name)
    utils::download.file(url,                                         # download file to path_data
                  paste0(path_data, zip_file_name),
                  method = download_method)
    # Extract directly the zip file from unzip
    dt_res <- fread(cmd = paste0("unzip -p ", path_data, zip_file_name))
  }

  setnames(dt_res, tolower(names(dt_res)) )

  if ( (aggregation_level != "us") || (target_year > 2007)){
    file.remove( paste0(path_data, zip_file_name ) )
  }

  return(dt_res)

} # end of download_cbp_data





