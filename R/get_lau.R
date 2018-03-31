#' Group all the functions
#'
#' @note downloads data from the Local Area Unemployment Statistics from the BLS
#' #'   Data is split and tidy




#' Download LAU County dataset from directly from the BLS website
#'
#' @param which_data what kind of data download: default are the county files
#' @param path_data  where does the download happen: default current directory
#' @param years      which year do we download, as of now only 1990 to 2016 are available
#' @param verbose    show intermediate steps
#' @return dt_res
#' @examples
#'   \dontrun{
#'     dt_lau <- get_lau_data(years = c(1995, 2000))
#'   }
#' @export
get_lau_data = function(
  which_data = "county",
  years      = seq(1990, 2016),
  path_data  = "./",
  verbose    = T
){

  fips_state <- NULL

  if (which_data == "county"){

    url <- "https://www.bls.gov/lau/laucnty"
    dt_res <- data.table()

    for (year_iter in years){

      year_iter = year_iter - 1900
      if (year_iter >= 100){ year_iter = year_iter - 100}
      if (year_iter < 10){ year_iter = paste0(0, year_iter) }

       utils::download.file(paste0(url, year_iter, ".xlsx"),
                     paste0(path_data, "lau_cty.xlsx"),
                     quiet = !verbose)

        dt_ind <- readxl::read_excel(paste0(path_data, "lau_cty.xlsx")) %>% data.table
        setnames(dt_ind, c("laus_code", "fips_state", "fips_cty",
                           "lau_name",  "date_y", "V1", "force", "employed", "level", "rate"))
        dt_ind <- dt_ind[ !is.na(as.numeric(fips_state)) ]
        dt_ind[, c("laus_code", "lau_name", "V1") := NULL ]

        dt_res <- rbind(dt_res, dt_ind)

    }

    # cleaning up
    file.remove( paste0(path_data, "lau_cty.xlsx") )

    # return dataset
    return( dt_res )


  }

} # end of get_lau_data


