#' Save dataframe to a stargazer/.txt table and MLFlow
#'
#' @param table dataframe/tibble Dataframe to save as a .txt table
#' @param table_path string Local path to save the table (.txt) to
#' @param title string Title of table
#'
#' @return
#' @export
#'
#' @examples
mlflow_log_table <- function(table, table_path, title = "Table Name"){
  stargazer::stargazer(table, type = "text", title = title, out = table_path, summary = FALSE)
  mlflow::mlflow_log_artifact(table_path)
}

#' Save plot to MLFlow
#'
#' @param plot object GGplot object
#' @param plot_path string Local path to save plot file to
#' @param height int Height of plot
#' @param width int Width of plot
#'
#' @return
#' @export
#'
#' @examples
mlflow_log_plot <- function(plot, plot_path, height=9, width=5){
  ggplot2::ggsave(plot_path, plot=plot, height=height, width=width)
  mlflow::mlflow_log_artifact(plot_path)
}
