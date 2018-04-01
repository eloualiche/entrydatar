library(testthat)
library(entrydatar)



# create directory within test
dir.create("./tmp_test_data")

test_check("entrydatar")

# current tests:
#  - BDS
#  - BED
#  - LAU
#  - NBF
#  - CBP
#  - QCEW
