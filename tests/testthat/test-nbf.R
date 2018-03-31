

context("Download the NBF data")

test_that("Get the NBF and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")


  dt_nbf <- get_nbf(year_start = 1980, year_end = 1990)

  # dataset structure
  expect_equal(colnames(dt_nbf),
               c("date_ym", "nbf_annual", "nbf", "nbi_annual", "nbi", "cbf_annual", "cbf"))

  # first row
  expect_equal(min(dt_nbf$date_ym), 198001)

  # clean up the mess
  unlink("./tmp_test_data")
})
