
#  ------------------------------------------------------------------------
#
# Title : Database Setup
#    By : Jimmy Briggs
#  Date : 2024-10-16
#
#  ------------------------------------------------------------------------


# setup for schema migrations ---------------------------------------------

#' Database Setup

db_setup <- function(conn, tbl_name = "migrations", tbl_schema = "public") {

  # check if schema exists
  if (!db_exists_schema(conn, schema)) {
    db_create_schema(conn, schema)
  }

  # check if migrations table exists
  if (!db_exists_table(conn, schema, "migrations")) {
    db_create_table_migrations(conn, schema)
  }

  # return
  return(TRUE)

}


# db_create_table_migrations ----------------------------------------------

#' @describeIn db_setup Create a migrations table in the database
#'
#' @param conn A database connection object.
#' @param tbl_name The name of the table to create.
#' @param tbl_schema The name of the schema to create the table in.
#'
#' @return TRUE if table is created, FALSE otherwise
#'
#' @export
db_create_table_migrations <- function(conn, tbl_name = "migrations", tbl_schema = "public") {

  # create table
  qry <- glue::glue(
    "CREATE TABLE {tbl_schema}.{tbl_name} (
      version TEXT PRIMARY KEY,
      applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )"
  )

  # execute query
  DBI::dbExecute(conn, qry)

  # return
  return(TRUE)

}

# create schema -----------------------------------------------------------

#' @describeIn db_setup Create a schema in the database
#'
#' @param conn A database connection object.
#' @param schema The name of the schema to create.
#'
#' @return TRUE if schema is created, FALSE otherwise
#'
#' @export
#'
#' @importFrom DBI dbExecute
db_create_schema <- function(conn, schema) {

  # create schema
  DBI::dbExecute(conn, paste0("CREATE SCHEMA ", schema))

  # return
  return(TRUE)

}

# check if schema exists --------------------------------------------------

#' @describeIn db_setup Check if a schema exists in the database
#'
#' @param conn A database connection object.
#' @param schema The name of the schema to check.
#'
#' @return TRUE if schema exists, FALSE otherwise
#'
#' @export
#'
#' @importFrom DBI dbGetQuery
db_exists_schema <- function(conn, schema) {

  qry <- paste0("SELECT schema_name FROM information_schema.schemata WHERE schema_name = '", schema, "'")

  # check if schema exists
  res <- DBI::dbGetQuery(conn, qry)

  # return
  return(nrow(res) > 0)

}
