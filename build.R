library(utils)
library(devtools)

use_r("directlfq")
use_r("check_function")

example_diann_res = read.table("../R_directlqf//test_data/unit_tests/input_table_formats/diann.tsv",sep = "\t",header = T)
use_data(example_diann_res)

use_readme_rmd()

## DIANN
df = read.table("../R_directlqf//test_data/unit_tests/input_table_formats/diann.tsv",sep = "\t",header = T)
example_diann_res = df
use_data(example_diann_res)
# directlfq(df,reformatted = F)

## MQ
df = read.table("../R_directlqf//test_data/unit_tests/input_table_formats/mq_peptides.txt",sep = "\t",header = T)
df2 = df[,c(36,1,71:82)]
colnames(df2)[1:2] = c("protein","ion")
# directlfq(df2,reformatted = T)

example_generic_input = df2
use_data(example_generic_input)

use_package("dplyr",type = "Imports")
use_package("reticulate",type = "Imports")
