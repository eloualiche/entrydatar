context("Download the BED data")

test_that("Get the BED and check variables", {
  skip_on_cran()

  dt_ind <- get_bed("industry")

  # dataset structure
  expect_equal(colnames(dt_ind),
               c("date_ym", "naics3", "year", "period", "ent_emp", "note1",
                 "exit_emp", "ent_cnt", "exit_cnt", "nent_emp", "nent_cnt"))

  # first row
  expect_equal(min(dt_ind$date_ym), 199209)


})
