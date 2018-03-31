context("Download the BDS data")

test_that("Get the BDS and check variables", {
   skip_on_cran()

   # create directory within test
   unlink("./tmp_test_data")
   dir.create("./tmp_test_data")


   dt_bds <- get_bds_cut(year_start = 1990, year_end = 1991,
                                    unit = "firm", aggregation = "all")

   # dataset structure
   expect_equal(colnames(dt_bds),
                c("year", "firms", "estabs", "emp", "denom", "estabs_entry", "estabs_entry_rate", "estabs_exit",
                  "estabs_exit_rate", "job_creation", "job_creation_births", "job_creation_continuers",
                  "job_creation_rate_births", "job_creation_rate", "job_destruction", "job_destruction_deaths",
                  "job_destruction_continuers", "job_destruction_rate_deaths", "job_destruction_rate", "net_job_creation",
                  "net_job_creation_rate", "reallocation_rate", "firmdeath_firms", "firmdeath_estabs", "firmdeath_emp"))

   # first row
   expect_equal(dt_bds$estabs, c(5408174, 5516902))

   # clean up the mess
   unlink("./tmp_test_data")
})
