context("Download the BED data")

test_that("Get the BED and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")

  dt_bed <- get_bed("industry")

  # dataset structure
  expect_equal(colnames(dt_bed),
               c("date_ym", "naics3", "year", "period", "ent_emp", "note1",
                 "exit_emp", "ent_cnt", "exit_cnt", "nent_emp", "nent_cnt"))

  # first row
  expect_equal(min(dt_bed$date_ym), 199209)

  #
  dt_bed <- get_bed_detail(download = T, path_data = "./")
  dt_bed <- data.table(dt_bed)
  expect_equal(colnames(dt_bed),
              c("series_id", "value", "date", "date_ym", "series_title"))
  expect_equal(min(dt_bed$date_ym), 199209)

  # clean up the mess
  unlink("./tmp_test_data")
})
