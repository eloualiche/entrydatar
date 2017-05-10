
#' Other code: loads data.table with option to write it for a given cut
#'
#' @param year_start: start year for which we want data
#' @param year_end: end year for which we want data
#' @param unit: establishment level or firm level
#' @param aggregation: download the quarterly files or the yearly files (default is quarterly)
#' @return data.table aggregate
#' @examples
#'   dt <- get_bds_cut(year_start = 1980, year_end = 2012,
#'                     unit = "firm", aggregation = "all")
#'                     
#' @export
get_bds_cut <- function(
  year_start  = 1977,
  year_end    = 2014,
  unit        = "firm",
  aggregation = "all"
){
    
    url_prefix = "http://www2.census.gov/ces/bds/"
    if (unit == "establishment"){
        url_prefix = paste0(url_prefix, "estab/")
    } else if (unit == "firm"){
        url_prefix = paste0(url_prefix, "firm/")
    }

    # define the path
    table_file_name = paste0("bds_", stringr::str_sub(unit, 1, 1), "_", aggregation, "_release.csv")
    url_download    = paste0(url_prefix, table_file_name)

    ## download.file(url_download, paste0(path_data, table_file_name))
    ## dt_census <- fread(paste0(path_data, table_file_name))

    # read it directly
    dt_census <- fread(url_download)

    setnames(dt_census, "year2", "year")
    dt_census <- dt_census[ year >= year_start & year <= year_end ]

    return(dt_census)
    
}

