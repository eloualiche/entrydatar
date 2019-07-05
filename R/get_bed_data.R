#' Group all the functions
#'
#' @note downloads data from the Entry Data from the Business Employment Dynamics Website
#'   Data is split and tidy




#' Download BED dataset from directly from the BLS website
#'
#' @param which_data what kind of data download: default is the main industry file
#' @param level      also keep the level of the variables (number of estabs and employment counts)
#' @param path_data  where does the download happen: default current directory (irrelevant since we read mostly from url)
#' @return df
#' @export
get_bed = function(
  which_data = "industry",
  level      = FALSE,
  path_data  = NULL
){

  # Avoid notes when checking package due to nse:
  series_id <- emp <- entry <- NULL
  ent_cnt <- ent_emp <-  ent_lvl_cnt <- ent_lvl_emp <- tot_count <- tot_emp <- NULL

    if (which_data == "industry"){
      url <- "http://www.bls.gov/web/cewbd/bd_data_ind3.txt"
      if (!is.null(path_data)){
        utils::download.file(url,
          paste0(path_data, "bed_ind.txt"),
          method = "wget")
        dt_ind <- fread(paste0(path_data, "bed_ind.txt"), skip = 1,
                        colClasses = c("character", "integer", "character", "numeric", "character", "character"))
      } else {
        dt_ind <- fread(url, skip=1,
                        colClasses = c("character", "integer", "character", "numeric", "character", "character") )
      }

      setnames(dt_ind, c("series_id", "year", "period", "entry", "note1", "note2") )
      dt_ind <- dt_ind[, !"note2", with=FALSE]
      dt_r_ind <- dt_ind[ grepl("BDS0000000000......1[12]000[36]RQ5*", series_id) ]  #use regex to get the 4 series at same time
      dt_r_ind$naics3  <- as.integer( substr( dt_r_ind$series_id, 17, 19) )
      dt_r_ind$emp     <- as.integer( substr( dt_r_ind$series_id, 21, 21) == "1" )
      dt_r_ind$open    <- as.integer( substr( dt_r_ind$series_id, 25, 25) == "3" )
      dt_r_ind$date_ym <- dt_r_ind$year*100 + as.integer(substr(dt_r_ind$period,2,3))*3

    # GET THE RATES
    dt_r_ind[, series_id:= NULL ]
    df1 <- dt_r_ind[ emp==1 & open ==1, !c("emp","open"), with=FALSE ] %>%
        dplyr::rename( ent_emp = entry )
    df2 <- dt_r_ind[ emp==1 & open ==0, !c("year","period","emp","open","note1"), with=FALSE] %>%
        dplyr::rename( exit_emp = entry )
    df3 <- dt_r_ind[ emp==0 & open ==1, !c("year","period","emp","open","note1"), with=FALSE] %>%
        dplyr::rename( ent_cnt = entry )
    df4 <- dt_r_ind[ emp==0 & open ==0, !c("year","period","emp","open","note1"), with=FALSE] %>%
        dplyr::rename( exit_cnt = entry )

    df <- merge( df1, df2, by = c("date_ym", "naics3"),  all.y=FALSE)
    df <- merge( df, df3, by = c("date_ym", "naics3"),  all.y=FALSE)
    df <- merge( df, df4, by = c("date_ym", "naics3"),  all.y=FALSE)

    df$nent_emp <- df$ent_emp - df$exit_emp
    df$nent_cnt <- df$ent_cnt - df$exit_cnt

    if (level == TRUE){

      dt_l_ind <- dt_ind[ grepl("BDS0000000000......1[12]000[36]LQ5*", series_id) ]  #use regex to get the 4 series at same time
      dt_l_ind$naics3  <- as.integer( substr( dt_l_ind$series_id, 17, 19) )
      dt_l_ind$emp     <- as.integer( substr( dt_l_ind$series_id, 21, 21) == "1" )
      dt_l_ind$open    <- as.integer( substr( dt_l_ind$series_id, 25, 25) == "3" )
      dt_l_ind$date_ym <- dt_l_ind$year*100 + as.integer(substr(dt_l_ind$period,2,3))*3

      dt_l_ind[, series_id:= NULL ]
      df1 <- dt_l_ind[ emp==1 & open ==1, !c("emp","open"), with=FALSE ] %>%
        dplyr::rename( ent_lvl_emp = entry )
      df2 <- dt_l_ind[ emp==1 & open ==0, !c("year","period","emp","open","note1"), with=FALSE] %>%
        dplyr::rename( exit_lvl_emp = entry )
      df3 <- dt_l_ind[ emp==0 & open ==1, !c("year","period","emp","open","note1"), with=FALSE] %>%
        dplyr::rename( ent_lvl_cnt = entry )
      df4 <- dt_l_ind[ emp==0 & open ==0, !c("year","period","emp","open","note1"), with=FALSE] %>%
        dplyr::rename( exit_lvl_cnt = entry )

      df_l <- merge( df1, df2, by = c("date_ym", "naics3"),   all.y=FALSE)
      df_l <- merge( df_l, df3, by = c("date_ym", "naics3"),  all.y=FALSE)
      df_l <- merge( df_l, df4, by = c("date_ym", "naics3"),  all.y=FALSE)

      df <- merge(df, df_l[, c("year", "period", "note1") := NULL ], by = c("date_ym", "naics3"))

      df[, tot_count := (ent_lvl_cnt / ent_cnt * 100) ]
      df[, tot_emp   := (ent_lvl_emp / ent_emp * 100) ]

    }

    # cleaning up (not necessary as we now directly read the url)
    # file.remove( paste0(path_data, "bed_ind.txt" ) )

    # return dataset
    return( df )


    }

} # end of get_bed
# ------------------------------------------------------------------------



#' Download BED dataset directly from the BLS website
#'
#' @param seasonaladj seasonality adjustment of the data; S (default) or U
#' @param msa msa code; 00000 (default) for national
#' @param state state code; 00 (default) for national
#' @param county county code; 000 (default) for national
#' @param industry industry code; 000000 (default) for total private. See docs for industry classifications
#' @param unitanalysis unit of observation; 1 (default) for establishment
#' @param dataelement which type of date; 2 (default) number of establishments, 1 employment
#' @param sizeclass firm size class; 00 (default) for all
#' @param dataclass for type of information; 07 (default) for Establishment Births, 01 Gross Job Gains, 02 Expansions, 03 Openings, 04 Gross Job Losses, 05 Contractions, 06 Closings, 07 Establishment Births, 08 Establishment Deaths
#' @param ratelevel for type of statistics; L (default) for level, R for rate
#' @param periodicity for sampling frequency; Q (default) for quarterly, A for annual
#' @param ownership for type of ownership; 5 (default) for private sector
#' @param download requires download confirmation
#' @param read FALSE is default, read RDS files if available (faster than downloading 200Mb file)
#' @param path_data where does the download happen: default current directory
#' @return dt_final
#' @examples
#' \dontrun{
#'   dt_bed <- get_bed_detail(download = T);
#'   }
#' @export
get_bed_detail <- function(
  seasonaladj  = "S",
  msa          = "00000",
  state        = "00",
  county       = "000",
  industry     = "000000", # Total Private
  unitanalysis = 1, # Establishment
  dataelement  = 2,# `1` Employment, `2` Number of Establishments
  sizeclass    = "00",
  dataclass    = "07",
  ratelevel    = "L", # `L` Level, `R` Rate
  periodicity  = "Q", # `A` Annual, `Q` Quarterly
  ownership    = 5,   # `5` Private Sector
  download     = F,
  read         = F,
  path_data    = "./"
){

  # Avoid notes when checking package due to nse:
  seasonal <- msa_code <- state_code <- county_code <- industry_code <- unitanalysis_code <- NULL
  dataelement_code <- sizeclass_code <- dataclass_code <- ratelevel_code <- periodicity_code <- NULL
  ownership_code <- series_id <- series_title <- period <- date_ym <- value <- NULL

  # Check if download is required
  d_choice <- TRUE
  if (download != TRUE){
    if (read == FALSE){
      d_choice = as.logical(
        utils::menu(c("No", "Yes"),
                    title = "Are you sure you want do download the BED flat file, size 225Mb?") - 1
      )
    } else if (read == TRUE){
      dt_all    <- readRDS(paste0(path_data, "bed_all.rds"))
      dt_lookup <- readRDS(paste0(path_data, "bed_lookup.rds"))
    }
  }

  # Download the flat file and the lookup table
  if (read == FALSE){
    if (download == TRUE | d_choice == TRUE){
      message("# Downloading files ...")
      message("# Download full flat file ...")
      utils::download.file("https://download.bls.gov/pub/time.series/bd/bd.data.1.AllItems",
                    paste0(path_data, "bed_all.txt") )
      message("# Download lookup table ...")
      utils::download.file("https://download.bls.gov/pub/time.series/bd/bd.series",
                    paste0(path_data, "bed_lookup.txt") )
    } else {
      stop("Could not download the flat BED file")
    }

    # read the file
    message("# Reading downloaded files ...")
    dt_all <- fread(paste0(path_data, "bed_all.txt"))
    dt_lookup <- fread(paste0(path_data, "bed_lookup.txt"), colClasses = rep("character", 19) )
  }


  dt_lookup <-
    dt_lookup[   seasonal          %in% seasonaladj  &
                 msa_code          %in% msa          &
                 state_code        %in% state        &
                 county_code       %in% county       &
                 industry_code     %in% industry     &
                 unitanalysis_code %in% unitanalysis &
                 dataelement_code  %in% dataelement  &
                 sizeclass_code    %in% sizeclass    &
                 dataclass_code    %in% dataclass    &
                 ratelevel_code    %in% ratelevel    &
                 periodicity_code  %in% periodicity  &
                 ownership_code    %in% ownership,
               list(series_id, series_title) ]

  dt_final <- dt_all[ series_id %in% dt_lookup$series_id ]
  dt_final[, date := as.Date(ISOdate(year, as.numeric(substr(period,2,3))*3, 1)) ]
  dt_final[, date_ym := year(date)*100+month(date) ]
  dt_final[, value := as.numeric(value) ]
  dt_final[, c("year", "period", "footnote_codes") := NULL ]
  dt_final <- merge(dt_final, dt_lookup, all.x = T, by = c("series_id"))

  # cleaning up
  if (read == FALSE){
  message("# Cleaning downloaded files ... \n")
    file.remove( paste0(path_data, "bed_all.txt" ) )
    file.remove( paste0(path_data, "bed_lookup.txt" ) )
  }

    # return dataset
    return( dt_final )

} # end of get_bed_detail
# ------------------------------------------------------------------------
