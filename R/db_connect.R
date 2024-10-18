
#  ------------------------------------------------------------------------
#
# Title : Database Connection
#    By : Jimmy Briggs
#  Date : 2024-10-16
#
#  ------------------------------------------------------------------------


# default database connect ------------------------------------------------

#' Database Connection
#'
#' @description
#' Connect to a database using the provided configuration.
#'
#' @param db_config A list containing the database connection configuration.
#' @param ... Additional arguments to pass to \code{DBI::dbConnect}.
#'
#' @return A database connection object.
#' @export
#'
#'@importFrom DBI dbConnect
db_connect <- function(db_config = NULL, ...) {

  # check if db_config is provided
  if (is.null(db_config)) {
    db_config <- db_config()
  }

  # check if db_config is a list
  if (!is.list(db_config)) {
    stop("db_config must be a list")
  }

  # check if db_config has required fields
  if (!all(c("host", "port", "dbname", "user", "password") %in% names(db_config))) {
    stop("db_config must have fields: host, port, dbname, user, password")
  }

  # connect to database
  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = db_config$dbname,
    host = db_config$host,
    port = db_config$port,
    user = db_config$user,
    password = db_config$password
  )

  # return connection
  return(conn)

}


# in memory database connection -------------------------------------------

#' @describeIn db_connect Connect to an local, in-memory database
#'
#' @export
#'
#' @importFrom DBI dbConnect
db_connect_local <- function(db_config = NULL, ...) {

  # connect to database
  conn <- DBI::dbConnect(
    RPostgres::Postgres(),
    dbname = ":memory:"
  )

  # return connection
  return(conn)

}

