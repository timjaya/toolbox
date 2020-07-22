#' Read in SQL file as a string
#'
#' @param filepath Path to SQL file
#'
#' @return string format of the SQL file
#' @export
#'
#' @examples
read_sql_file <- function(filepath){
  con = file(filepath, "r")
  sql.string <- ""
  while (TRUE){
    line <- readLines(con, n = 1, warn=FALSE)
    if ( length(line) == 0 ){
      break
    }
    line <- gsub("\\t", " ", line)
    if(grepl("--",line) == TRUE){
      line <- paste(sub("--","/*",line),"*/")
    }
    sql.string <- paste(sql.string, line)
  }
  close(con)
  return(sql.string)
}

#' Create a connection object to Teradata to then run queries with.
#'
#' Developed for both windows and mac.
#'
#' @param td_id string: Teradata ID
#' @param password string: Teradata password (only for Mac)
#' @param jdbc_class_path string: Path to terajdbc4.jar (only for Mac)
#' @param url_td: url to DB
#'
#' @return teradata connection object that is used to run queries
#'
#' @export
create_td_connection <- function(td_id, password = NULL, jdbc_class_path = "~/terajdbc4.jar", url_td = NULL){

  os <- Sys.info()['sysname']
  if (os == "Windows") {
    DBI::dbConnect(odbc::odbc(), td_id)
  } else if (os == "Darwin") {
    td_driver <- RJDBC::JDBC(driverClass = "com.teradata.jdbc.TeraDriver",
                             classPath = jdbc_class_path,
                             identifier.quote = "'")
    RJDBC::dbConnect(drv = td_driver,
                     url = url_td,
                     user = td_id,
                     pass = password)
  }
}

#' Run queries with teradata connection
#'
#' @param td_con object: TD connection object from create_teradata_connection()
#' @param sql_query string: SQL query to run. Can be multi-line.
#'
#' @return tibble: Dataframe of SQL results
#' @export
run_query <- function(td_con, sql_query) {
  # Helper: extract sql verb from sql query string
  extract_sql_verb <- function(query){
    str_split(trimws(str_replace_all(query, c("\n" = " ", "\t" = " "))), " ")[[1]][1]
  }

  os <- Sys.info()['sysname']

  if (str_detect(sql_query, "COLLECT STATS")) {
    abort("Temp queries cannot contain COLLECT STATS when using R")
  }
  if (!str_detect(sql_query, ";")) {
    abort("No semicolon detected. Make sure SQL formatted properly and semicolons are in place.")
  }
  if (sql_query %>% str_replace_all("\n", "") %>% trimws() %>% stringr::str_sub(start=-1) != ";") {
    abort("Statement doesn't end with ';'. Make sure SQL formatted properly and semicolons are in place.")
  }

  # # reformat SQL query, especially if its a multi-line SQL query
  sql_query <- invisible(sql_query %>%
                           str_split(";") %>%
                           pluck(1) %>%
                           map(~str_c(.x, ";"))
  )

  sql_query <- sql_query[1:length(sql_query)-1]

  if (os == "Windows") {
    result <- sql_query %>% map(~odbc::dbGetQuery(td_con, .x))
    result <- result[length(result)][[1]]
  } else if (os == "Darwin") {
    for (q in sql_query){
      verb <- tolower(extract_sql_verb(q))
      if (verb == "create")  RJDBC::dbSendUpdate(td_con, q)
      else if (verb == "select" | verb == "sel") result <- RJDBC::dbGetQuery(td_con, q)
      else RJDBC::dbSendUpdate(td_con, q)
    }
  } else {
    abort("OS type not supported")
  }

  result %>% tibble::as_tibble()
}
