context("Download the CBP data")

test_that("Get the CBP and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")

  library(purrr)

  size_col <- c("1_4", "5_9", "10_19", "20_49", "50_99", "100_249", "250_499", "500_999", "1000")
  county_col_cbp <- c("fipstate", "fipscty", "naics", "empflag", "emp", "qp1", "ap", "est", paste0("n", size_col),
                        "n1000_1", "n1000_2", "n1000_3", "n1000_4", "censtate", "cencty", "year")

  us_col_cbp <- c("uscode", "naics", "empflag", "emp", "qp1", "ap", "est",
                  unlist(purrr::map(purrr::cross2(c("f", "e", "q", "a", "n"), size_col), ~ paste0(.x[[1]], .x[[2]]))),
                  "year")

  state_col_cbp <- c("fipstate", "naics", "empflag", "emp", "qp1", "ap", "est",
                     unlist(purrr::map(purrr::cross2(c("f", "e", "q", "a", "n"), size_col), ~ paste0(.x[[1]], .x[[2]]))),
                     "censtate", "year")

  msa_col_cbp <- c("msa", "naics", "empflag", "emp", "qp1", "ap", "est", paste0("n", size_col), "year")

  # ---------------------------------------------------------------------------
  # Get the data: COUNTY
  dt_cbp_cty <- download_all_cbp(year_start = 2000, year_end = 2001,
                             aggregation_level = "county", path_data = "./tmp_test_data/")
  # dataset structure
  expect_equal(colnames(dt_cbp_cty),county_col_cbp)
  # first row
  expect_equal(min(dt_cbp_cty$year), 2000)

  # ---------------------------------------------------------------------------
  # US LEVEL
  dt_cbp <- download_all_cbp(year_start = 2000, year_end = 2000,
                   aggregation_level = "us", path_data = "./tmp_test_data")
  expect_equal(colnames(dt_cbp), us_col_cbp)
  # ---------------------------------------------------------------------------
  # STATE LEVEL
  dt_cbp <- download_all_cbp(year_start = 2000, year_end = 2000,
                             aggregation_level = "state", path_data = "./tmp_test_data/")
  expect_equal(colnames(dt_cbp), state_col_cbp)
  # ---------------------------------------------------------------------------
  # MSA LEVEL
  dt_cbp <- download_all_cbp(year_start = 2000, year_end = 2000,
                             aggregation_level = "msa", path_data = "./tmp_test_data/")
  expect_equal(colnames(dt_cbp), msa_col_cbp)

  # ---------------------------------------------------------------------------
  # Tidy the data
  dt_tidy <- tidy_cbp(dt_cbp_cty)
  expect_equal(nrow(dt_tidy), 4360489)
  expect_equal(min(dt_tidy$year), 2000)

  # clean up the mess
  unlink("./tmp_test_data", recursive = T)
})
