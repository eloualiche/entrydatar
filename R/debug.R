# library(pacman)
# p_load(data.table, bit64, dplyr, magrittr)
#
# dt_tmp <- fread("~/Downloads/2014.annual.singlefile.csv")
#
# dt_tmp[, list(agglvl_code) ] %>% unique %>% arrange(agglvl_code)
#
#
# qcewGetIndustryData <- function (year, qtr, industry) {
# 	url <- "http://www.bls.gov/cew/data/api/YEAR/QTR/industry/INDUSTRY.csv"
# 	url <- sub("YEAR", year, url, ignore.case=FALSE)
# 	url <- sub("QTR", qtr, url, ignore.case=FALSE)
# 	url <- sub("INDUSTRY", industry, url, ignore.case=FALSE)
# 	read.csv(url, header = TRUE, sep = ",", quote="\"", dec=".", na.strings=" ", skip=0)
# }
#
# Construction <- qcewGetIndustryData("2013", "1", "1012")
# Construction <- data.table(Construction)
# Construction[ own_code == 5, list(size_code) ]
#
# dt_tmp <- fread("~/Downloads/2015.q1.by_size.csv")
# dt_tmp[ agglvl_code == 25, list(size_code, qtr, industry_code) ]
#
# dt_tmp <- fread("~/Downloads/cbp13co.txt")
# dt_tmp
#
#
# target_year <- 1996
#
# if (target_year >= 2002){
#     path1 <- paste0("econ", target_year, "/")
# } else {
#     path1 <- "Econ2001_And_Earlier/"
# }
#
# path2 <- paste0("CBP_CSV/")
# zip_file_name <- paste0("cbp", target_year %% 100, "co.zip")
# file_name <- paste0("cbp", target_year %% 100, "co.txt")
#
# url <- paste0("ftp://ftp.census.gov/", path1, path2, zip_file_name)
# url
#
# download.file(url,
#               paste0(path_data, zip_file_name) )           # download file to path_data
#
# unzip(paste0(path_data, zip_file_name), exdir = path_data) # extract the file in path_data
#
# fread(paste0(path_data, file_name))
#
# file.remove( paste0(path_data, zip_file_name ) )
# file.remove( paste0(path_data, file_name ) )
#
