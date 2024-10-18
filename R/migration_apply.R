apply_migration <- function(
  conn,
  migration_file,
  version,
  direction = c("up", "down")
) {

  check_db_conn(conn)
  rlang::arg_match(direction)

  migration_sql <- parse_migration_script(migration_file)

  sql_to_execute <- switch(
    direction,
    up = migration_sql$sql_up,
    down = migration_sql$sql_down
  )

  # execute migration
  DBI::dbBegin(conn)

  tryCatch({

    DBI::dbExecute(conn, sql_to_execute)

    if (direction == "up") {

      # Record the migration as applied
      DBI::dbExecute(
        conn,
        "INSERT INTO schema_migrations (version, applied_at) VALUES (?, ?)",
        params = list(version, Sys.time())
      )

    } else {

      # Remove the migration record
      DBI::dbExecute(
        conn,
        "DELETE FROM schema_migrations WHERE version = ?",
        params = list(version)
      )

    }

    # commit
    DBI::dbCommit(conn)
    cli::cli_alert_success(
      "Migration {.field {version}} applied ({.field {direction}})."
    )

  }, error = function(e) {

    DBI::dbRollback(conn)
    cli::cli_abort(
      "Migration {.field {version}} failed ({.field {direction}}): {e$message}"
    )

  })

  return(invisible(NULL))

}

apply_pending_migrations <- function(conn) {
  applied <- get_applied_migrations(conn)
  available <- get_available_migrations()
  pending <- setdiff(names(available), applied)

  if (length(pending) == 0) {
    cli::cli_alert_info("No pending migrations.")
    return()
  }

  for (version in sort(pending)) {
    cli::cli_alert_info("Applying migration: {.val {version}}")
    apply_migration(conn, available[[version]], version, direction = "up")
  }
}

