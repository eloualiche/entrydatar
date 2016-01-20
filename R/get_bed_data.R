#' Group all the functions
#'
#' @note downloads data from the Entry Data from the Business Employment Dynamics Website
#'   Data is split and tidy




#' Download BED dataset from directly from the BLS website
#'
#' @param which_data: what kind of data download: default is the main industry file
#' @param path_data: where does the download happen: default current directory
#' @return df_res.
#' @export
get_bed_data = function(
  which_data = "industry",
  path_data = "./"
){

    if (which_data == "industry"){

        url <- "http://www.bls.gov/web/cewbd/bd_data_ind3.txt"
        download.file(url,
                      paste0(path_data, "bed_ind.txt") )

        dt_ind <- fread(paste0(path_data, "bed_ind.txt"), skip=1,
                        colClasses = c("character", "integer", "character", "numeric", "character", "character") )

        setnames(dt_ind, c("series_id", "year", "period", "entry", "note1", "note2") )
        dt_ind <- dt_ind[, !"note2", with=FALSE]

        dt_ind <- dt_ind[ grepl("BDS0000000000......1[12]000[36]RQ5*", series_id) ]  #use regex to get the 4 series at same time
        dt_ind$naics3 <- as.integer( substr( dt_ind$series_id, 17, 19) )
        dt_ind$emp  <- as.integer( substr( dt_ind$series_id, 21, 21) == "1" )
        dt_ind$open <- as.integer( substr( dt_ind$series_id, 25, 25) == "3" )
        dt_ind$date_ym <- dt_ind$year*100 + as.integer(substr(dt_ind$period,2,3))*3

        dt_ind

    ########################################################
    ## play with industries
    ## list_naics3 <- levels(factor(dt_ind$naics3))
    ## download industry definition from us census and append them: https://www.census.gov/cgi-bin/sssd/naics/naicsrch?chart=2012
    ## setnames(census_ind,c("seq", "naics3", "ind_def") )
    ## census_ind <- census_ind[, !"seq", with=FALSE]
    ## census_ind$naics3 <- as.integer( census_ind$naics3)
    ## # merge with the industry BLS file
    ## dt_ind <- dt_ind %>% left_join( census_ind, by="naics3" ) %>% data.table

# test to check if this matches the BLS website definitions: http://www.bls.gov/bdm/bdmind3.htm
    ## dt_ind[ emp==0 & naics3==311 ]
    ## dt_ind[ emp==1 & naics3==311 ]
# match

    dt_ind[, series_id:= NULL ]
    df1 <- dt_ind[ emp==1 & open ==1, !c("emp","open") , with=FALSE ] %>%
        rename( ent_emp = entry )
    df2 <- dt_ind[ emp==1 & open ==0, !c("year","period","emp","open","note1") ,with=FALSE] %>%
        rename( exit_emp = entry )
    df3 <- dt_ind[ emp==0 & open ==1, !c("year","period","emp","open","note1") ,with=FALSE] %>%
        rename( ent_cnt = entry )
    df4 <- dt_ind[ emp==0 & open ==0, !c("year","period","emp","open","note1") ,with=FALSE] %>%
        rename( exit_cnt = entry )

    df <- merge( df1, df2, by = c("date_ym", "naics3"),  all.y=FALSE)
    df <- merge( df, df3, by = c("date_ym", "naics3"),  all.y=FALSE)
    df <- merge( df, df4, by = c("date_ym", "naics3"),  all.y=FALSE)

    df$nent_emp <- df$ent_emp - df$exit_emp
    df$nent_cnt <- df$ent_cnt - df$exit_cnt

    # cleaning up
    file.remove( paste0(path_data, "bed_ind.txt" ) )

    # return dataset
    return( df )


    }

} # end of download_data


