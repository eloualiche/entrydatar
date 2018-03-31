context("Download the QCEW data")

test_that("Get the QCEW and check variables", {
  skip_on_cran()

  # create directory within test
  unlink("./tmp_test_data")
  dir.create("./tmp_test_data")

  # lots of different cuts:

  # 1. start with non size cut NAICS
  # 10 is national total
  dt_qcew <- get_files_cut(data_cut = 10, year_start = 1991, year_end =1993,
                           path_data = "./tmp_test_data/", write = T)

  # 23 is Supersector x national x size
  dt_qcew <- get_files_cut(data_cut = 23, year_start = 1991, year_end =1993,
                           path_data = "./tmp_test_data/", write = T)

  dt_tidy <- tidy_qcew(dt_qcew, industry = "naics", frequency = "all")
  dt_tidy <- tidy_qcew_year(dt_qcew, industry = "naics", frequency = "all")

  # 2. check the sic data works as well
  dt_qcew <- get_files_cut(data_cut = 14, year_start = 1991, year_end =1993,
                           industry = "sic",
                           path_data = "./tmp_test_data/", write = T)

  # 23 is Supersector x national x size
  dt_qcew <- get_files_cut(data_cut = 24, year_start = 1991, year_end =1993,
                           industry = "sic",
                           path_data = "./tmp_test_data/", write = T)

  dt_tidy <- tidy_qcew(dt_qcew, industry = "sic", frequency = "all")


  # clean up the mess
  unlink("./tmp_test_data")
})
