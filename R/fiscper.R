#' Fiscper functions
#'
#' Imported from markfairbanks/graingr
#'
#' Extract info from fiscper
#'
#' @param fiscper
#'
#' Column containing the fiscper
#'
#' @return
#' @export
#'
#' @examples
fiscper_year <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  as.numeric(stringr::str_sub(fiscper, 1, 4))
}


#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_month <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  as.numeric(stringr::str_sub(fiscper, 6, 7))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_date <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  lubridate::make_date(fiscper_year(fiscper),
                       fiscper_month(fiscper))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_quarter <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  lubridate::quarter(fiscper_date(fiscper))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_semester <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  lubridate::semester(fiscper_date(fiscper))
}

#' @rdname fiscper
#' @export
#' @inherit fiscper_year
fiscper_workdays <- function(fiscper) {
  if (nchar(fiscper) != 7 || is.numeric(fiscper) == FALSE) {
    rlang::abort("Fiscper must be formatted as YYYY0MM and be numeric")
  }
  purrr::map_dbl(fiscper, ~work_days_df[work_days_df$fiscper == .x,]$work_days)

}

#' @rdname fiscper
#' @export
#' @param year int of year
#' @param month int of month
#' @inherit fiscper_year
make_fiscper <- function(year, month) {
  if (any(nchar(year) != 4)) {
    rlang::abort("Year must be 4 digits")
  }

  if (any(nchar(month) == 0) | any(nchar(month) > 2)) {
    rlang::abort("Month must be one or two digits")
  }

  year <- as.numeric(year)
  month <- as.numeric(month)

  as.numeric(
    ifelse(nchar(month) == 2,
           stringr::str_c(year, "0", month),
           stringr::str_c(year, "00", month))
  )
}
