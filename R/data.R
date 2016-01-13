
#' Data that matches QCEW sic industry_code with actual sic codes with description
#'
#' Raw data version in data_raw/qcew_sic_match
#' Also available on the BLS [website](http://www.bls.gov/cew/doc/titles/industry/sic_industry_titles.htm)
#'
#' Variables are as follows
#'
#' @format A dataframe with 1749 rows and 3 columns
#' \itemize{
#'   \item csv_industry_code: string SIC_0**
#'     that matches to the downloaded sic csv format files
#'   \item ewb_industry_code: string 0**
#'     that matches to the downloaded sic ewb format files
#'   \item industry_title: "SIC XXX "
#'     and description of the matching industry
#' }
"qcew_sic_des"
