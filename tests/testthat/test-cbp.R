context("Download the CBP data")

test_that("Get the CBP and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")

  # Get the data
  dt_cbp <- download_all_cbp(year_start = 2000, year_end = 2001,
                             aggregation_level = "county", path_data = "./tmp_test_data/")

  # dataset structure
  expect_equal(colnames(dt_cbp),
               c("fips_state", "fips_cty", "date_y", "force", "employed", "level", "rate"))
  # first row
  expect_equal(min(dt_cbp$date_y), "2000")

  # Tidy the data
  dt_tidy <- tidy_cbp(dt_cbp)

  expect_equal(min(dt_tidy$date_y), "2000")

  # clean up the mess
  unlink("./tmp_test_data")
})
