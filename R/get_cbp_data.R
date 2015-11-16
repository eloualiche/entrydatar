#' Group all the functions
#'
#' @note downloads data from the County Business Pattern
#'   for desired years, splitting data by the aggregation level codes
#'   the docs for the CBP is available at the following:
#'   http://www.census.gov/econ/cbp/download/full_layout/County_Layout_SIC.txt

#' Download one year of county business pattern dataset
#'
#' @param target_year: year for which we want to download the data
#' @param path_data: where does the download happen: default current directory
#' @return data.table
download_cbp_data <- function(
  target_year,
  path_data = "~/Downloads/"
){

  if (target_year >= 2002){
    path1 <- paste0("econ", target_year, "/")
  } else {
    path1 <- "Econ2001_And_Earlier/"
  }

  path2 <- paste0("CBP_CSV/")
  zip_file_name <- paste0("cbp", target_year %% 100, "co.zip")
  file_name <- paste0("cbp", target_year %% 100, "co.txt")

  url <- paste0("ftp://ftp.census.gov/", path1, path2, zip_file_name)

  download.file(url,
                paste0(path_data, zip_file_name) )           # download file to path_data

  unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data

  dt_res <- fread(paste0(path_data, file_name))

  file.remove( paste0(path_data, zip_file_name ) )
  file.remove( paste0(path_data, file_name ) )

  return(dt_res)

}

#' Download the CBP
#'
#' @param target_year: year for which we want to download the data
#' @param path_data: where does the download happen: default current directory
#' @return data.table
#' @export
download_all_cbp <- function(
  year_start = 1996,
  year_end   = 2013,
  path_data = "~/Downloads/"
){

    dt_res <- data.table()

    for (year in seq(year_start, year_end)){

      message(paste0("Downloading and processing year: ", year))
      dt_year <- download_cbp_data(target_year = year, path_data = path_data)
      dt_year[, year := year ]
      dt_res  <- rbind(dt_res, dt_year, fill = T)

    }

  return(dt_res)

}
