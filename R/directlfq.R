

#' Run directlfq
#'
#' This function perform directlfq via the [directlfq]("https://github.com/MannLabs/directlfq/") module.
#'
#' @param df A dataframe in the generic input format of directlfq with the following columns: "protein", "ion", runs.
#' @param ncores Use howmany cores, default is 4. If it is 0, will use all available threads.
#' @param tempdir The path of temp files.
#' @param reformatted If TRUE means df is in generic input format, else df is a result table from quantity.
#' We recommend use a formatted input
#' @param ... To be completed in the future. Other parameters passed to directlfq.
#'
#' @details
#' Specifically, this R package installs a conda environment containing the directlfq library using reticulate.
#' Then, directlfq calculations are performed by calling Python scripts within that environment.
#' This function will try to
#' Or, you can set up the required conda environment by running the check_directlfq_Module() function.
#' If you are a Windows user, you may need to run this function with administrator privileges.
#' The directlfq function will also attempt to deploy this conda environment if it is missing.
#'
#' @return
#' A dataframe contains the directlfq result, protein intensities.
#'
#' @export
#'
#' @import dplyr reticulate
#' @examples
#' ## A diann report.tsv
#' data(example_diann_res)
#' pro_int = directlfq(example_diann_res,reformatted = F)
#'
#' ## A generic input table, which has been reformatted.
#' data(example_generic_input)
#' pro_int = directlfq(example_generic_input, reformatted = T)
#'
directlfq <- function(df, ncores = 4, temp_dir = tempdir(), reformatted = T, ...){
  if(check_directlfq_Module()){
    cat("Confirmation passed, the directlfq py module is verified as installed in your environment.\n")

    # write a csv table
    if(reformatted){
      in_file = file.path(temp_dir, "temp_input_directlfq.aq_reformat.tsv")
    }else{
      in_file = file.path(temp_dir, "temp_input_directlfq.tsv")
    }
    write.table(df, file = in_file, sep = "\t", row.names = FALSE,quote = F)

    py_path = reticulate::conda_list() %>% filter(name == "directlfq") %>% select(python)
    cat(paste("python path is:",py_path,"\n"))

    script_path = system.file("py_scripts","run_lfq_script.py", package = "Rdirectlfq")
    script_path = paste0('"',script_path,'"')
    # script_path = "./inst/run_lfq_script.py"

    # in_file = "../R_directlqf/test_data/unit_tests/input_table_formats/diann.tsv"
    # in_file = "../R_directlqf/test_data/unit_tests/input_table_formats/mq_peptides.txt"
    command = paste(py_path, script_path, in_file, ncores)
    res = system(command)

    if(res == 0){
      the_out = read.table(paste0(in_file,".protein_intensities.tsv"),header = T)
      message("Finnished!")
      return(the_out)
    }else{
      message("Encountered error when running directlfq. Please check your input.")
    }
  }else{
    message("Interrupted running because directlfq is not correctly installed. Run check_directlfq_Module to install the module.")
  }

  return(NULL)
}



