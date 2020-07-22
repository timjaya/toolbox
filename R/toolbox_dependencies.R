# Suppress R CMD check note
#' @importFrom stringr str_split str_detect str_c str_replace_all str_glue str_sub
#' @importFrom rlang warn abort inform
#' @importFrom purrr map pluck
#' @importFrom lubridate quarter semester make_date
#' @importFrom dplyr slice pull
#' @importFrom mlflow mlflow_log_metric mlflow_log_param mlflow_log_artifact
#' @importFrom ggplot2 ggsave
NULL

globalVariables(c("td_con", "td_id", "password", "jdbc_class_path"))
