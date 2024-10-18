
#  ------------------------------------------------------------------------
#
# Title : Migration Get Functions
#    By : Jimmy Briggs
#  Date : 2024-10-16
#
#  ------------------------------------------------------------------------


# get applied migrations --------------------------------------------------

#' Get Applied Migrations
#'

get_applied_migrations <- function(
    conn,
    tbl_name = "migrations",
    tbl_schema = "public"
) {

  # check conn
  if (!DBI::dbIsValid(conn)) {
    stop("Invalid database connection")
  }

  # specify schema and table as SQL ID
  tbl_schema <- DBI::Id(schema = tbl_schema, table = tbl_name)

  # check if table exists in schema
  if (!DBI::dbExistsTable(conn, tbl_schema)) {
    cli::cli_alert_warning(
      "Schema migrations table {.field {paste0(schema_name, '.', tbl_name)}} does not exist."
    )
    # prompt user if wants to create
    create <- readline("Would you like to create the table? (y/n): ")
    if (tolower(create) == "y") {
      cli::cli_alert_info("Creating schema migrations table...")
      db_setup(conn, tbl_name = tbl_name, tbl_schema = tbl_schema)
    } else {
      return(NULL)
    }
  }

  # specify qry
  qry <- glue::glue(
    "SELECT version FROM {tbl_schema}.{tbl_name} ORDER BY version"
  )

  # execute qry
  res <- DBI::dbGetQuery(conn, qry)
  return(res$version)

}

# available migrations ----------------------------------------------------

get_available_migrations <- function() {

  migrations_path <- system.file("migrations", package = "migrate")
  migrations <- fs::dir_ls(migrations_path, glob = "*.sql")
  names(migrations) <- basename(migrations)
  return(migrations)

}

