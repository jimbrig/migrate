create_migration <- function(
  name,
  sql_up = "",
  sql_down = "",
  overwrite = FALSE,
  open = TRUE
) {

  migrations_dir <- file.path(getwd(), "migrations")

  if (!fs::dir_exists(migrations_dir)) {
    cli::cli_alert_info("Creating migrations directory.")
    fs::dir_create(migrations_dir)
  }

  version <- format(Sys.time(), "%Y%m%d%H%M%S")
  filename <- paste0(version, "_", name, ".sql")
  save_as <- file.path("migrations", filename)

  data <- list(
    version = version,
    name = name,
    date = as.character(Sys.time()),
    sql_up = sql_up,
    sql_down = sql_down
  )

  use_template(
    template = "migration.template.sql",
    save_as = save_as,
    data = data,
    overwrite = overwrite,
    open = open,
    package = "migrate"
  )

  cli::cli_alert_success("Migration script created at: {.path {save_as}}.")

  return(invisible(NULL))

}

