context("Download the LAU data")

test_that("Get the BED and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")

  dt_lau <- get_lau_data(years = c(1995, 2000), path_data = "./tmp_test_data")

  # dataset structure
  expect_equal(colnames(dt_lau),
               c("fips_state", "fips_cty", "date_y", "force", "employed", "level", "rate"))

  # first row
  expect_equal(min(dt_lau$date_y), "1995")

  # clean up the mess
  unlink("./tmp_test_data")
})
