
#' Other code: loads data.table with option to write it for a given cut
#'
#' @param year_start: start year for which we want data
#' @param year_end: end year for which we want data
#' @return data.table aggregate
#' @examples
#'   dt <- get_nbf(year_start = 1980, year_end = 2012)
#'
#' @export
get_nbf <- function(
  year_start  = 1948,
  year_end    = 2014
){

    dt_nbf <- copy(entrydatar::scb)[
      floor(date_ym/100)>=year_start & floor(date_ym/100)<=year_end ]

    return(dt_nbf)

}
