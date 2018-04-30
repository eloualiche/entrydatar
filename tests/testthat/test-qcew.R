context("Download the QCEW data")

test_that("Get the QCEW and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")


  # =====================================================================================
  # 1. start with non size cut NAICS, download the files
  file_name_1991 <- download_qcew_data(
    target_year = c(1991),
    industry = "naics", frequency = "quarter",
    path_data = "./",
    verbose = T)

  # 10 is national total, 17 is 5-digit
   dt_qcew <- get_qcew_cut(data_cut = c(10, 17),
                           year_start = 1991, year_end = 1992,
                           path_data = ".", subdir = F,
                           write = F, download = "")
  #
  expect_equal(nrow(dt_qcew[agglvl_code == 10]), 8)
  expect_equal(nrow(dt_qcew[agglvl_code == 17]), 8656)
  expect_equal(colnames(dt_qcew),
               c("area_fips", "own_code", "industry_code", "agglvl_code", "size_code", "year", "qtr",
                 "disclosure_code", "qtrly_estabs", "month1_emplvl", "month2_emplvl", "month3_emplvl",
                 "total_qtrly_wages", "taxable_qtrly_wages", "qtrly_contributions", "avg_wkly_wage",
                 "lq_disclosure_code", "lq_qtrly_estabs", "lq_month1_emplvl", "lq_month2_emplvl",
                 "lq_month3_emplvl", "lq_total_qtrly_wages", "lq_taxable_qtrly_wages", "lq_qtrly_contributions",
                 "lq_avg_wkly_wage", "oty_disclosure_code", "oty_qtrly_estabs_chg", "oty_qtrly_estabs_pct_chg",
                 "oty_month1_emplvl_chg", "oty_month1_emplvl_pct_chg", "oty_month2_emplvl_chg", "oty_month2_emplvl_pct_chg",
                 "oty_month3_emplvl_chg", "oty_month3_emplvl_pct_chg", "oty_total_qtrly_wages_chg",
                 "oty_total_qtrly_wages_pct_chg", "oty_taxable_qtrly_wages_chg", "oty_taxable_qtrly_wages_pct_chg",
                 "oty_qtrly_contributions_chg", "oty_qtrly_contributions_pct_chg", "oty_avg_wkly_wage_chg",
                 "oty_avg_wkly_wage_pct_chg"))

  # do the tidy function
  dt_tidy <- tidy_qcew(dt_qcew, industry = "naics", frequency = "all")
  expect_equal(nrow(dt_tidy), 25992)
  expect_equal(colnames(dt_tidy),
              c("year", "quarter", "industry_code", "own_code", "area_fips", "size_code", "agglvl_code",
                "month", "emplvl", "total_qtrly_wages", "taxable_qtrly_wages", "qtrly_contributions", "avg_wkly_wage",
                "qtrly_estabs", "lq_qtrly_estabs", "disclosure_code"))


  dt_tidy_year <- tidy_qcew_year(dt_qcew, industry = "naics", frequency = "all")
  expect_equal(nrow(dt_tidy_year), 25992)
  expect_equal(colnames(dt_tidy_year),
               c("year", "quarter", "industry_code", "own_code", "area_fips", "size_code", "agglvl_code",
                 "month", "emplvl", "total_qtrly_wages", "taxable_qtrly_wages", "qtrly_contributions", "avg_wkly_wage",
                "qtrly_estabs", "lq_qtrly_estabs", "disclosure_code"))
  # =====================================================================================
  # TEST THE SIC FOR OLD AND NEWS FILES
  dt_sic_qcew <- get_qcew_cut(data_cut=c(06),
                              year_start = 1984, year_end = 1984,
                              industry = "sic", frequency = "quarter",
                              subdir = F, path_data = ".",
                              write = F, download = "")

  # expect_equal(nrow(dt_sic_qcew[agglvl_code == "06"]), 11639)
  expect_equal(colnames(dt_sic_qcew),
               c("area_fips", "own_code", "industry_code", "agglvl_code", "size_code", "year", "qtr",
                 "disclosure_code", "qtrly_estabs_count", "month1_emplvl", "month2_emplvl", "month3_emplvl",
                 "total_qtrly_wages", "taxable_qtrly_wages", "qtrly_contributions", "avg_wkly_wage",
                 "old_industry_code", "sic"))

  # =====================================================================================
  # OTHER USEFUL FUNCTIONS
  file_name <- download_qcew_data(target_year = 2000, industry = "naics", frequency = "quarter",
                                  path_data = "", url_wayback = "",
                                  download = F) # key thing here is to test the new read directly the zip files
  expect_equal(typeof(file_name), "character")


  # # =====================================================================================
  # # 23 is Supersector x national x size
  # dt_qcew <- get_qcew_cut(data_cut = 23, year_start = 1991, year_end =1992,
  #                          path_data = "./tmp_test_data/", write = T)
  #
  # # 2. check the sic data works as well
  # dt_qcew <- get_qcew_cut(data_cut = 14, year_start = 1991, year_end =1993,
  #                          industry = "sic",
  #                          path_data = "./tmp_test_data/", write = T)

  # dt_tidy <- tidy_qcew(dt_qcew, industry = "sic", frequency = "all")


  # clean up the mess
  unlink("./tmp_test_data", recursive = T)
})
