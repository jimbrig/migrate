rollback_migrations <- function(conn, steps = 1) {
  applied <- get_applied_migrations(conn)

  if (length(applied) == 0) {
    cli::cli_alert_info("No migrations have been applied.")
    return()
  }

  to_rollback <- tail(sort(applied), steps)

  for (version in rev(to_rollback)) {
    cli::cli_alert_info("Rolling back migration: {.val {version}}")
    migration_file <- get_available_migrations()[[version]]
    apply_migration(conn, migration_file, version, direction = "down")
  }
}
