context("Download the CBP data")

test_that("Get the CBP and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")

  # Get the data
  dt_cbp <- download_all_cbp(year_start = 2000, year_end = 2001,
                             aggregation_level = "county", path_data = "./tmp_test_data/")

  dt_cbp
  # dataset structure
  expect_equal(colnames(dt_cbp),
               c("fipstate", "fipscty", "naics", "empflag", "emp", "qp1", "ap", "est", "n1_4",
                 "n5_9", "n10_19", "n20_49", "n50_99", "n100_249", "n250_499", "n500_999",
                 "n1000", "n1000_1", "n1000_2", "n1000_3", "n1000_4", "censtate", "cencty", "year"))

  # first row
  expect_equal(min(dt_cbp$year), 2000)

  # Tidy the data
  dt_tidy <- tidy_cbp(dt_cbp)
  expect_equal(nrow(dt_tidy), 4360489)
  expect_equal(min(dt_tidy$year), 2000)

  # clean up the mess
  unlink("./tmp_test_data", recursive = T)
})
