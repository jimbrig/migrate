parse_migration_script <- function(migration_file) {

  content <- read_utf8(migration_file)
  content <- paste(content, collapse = "\n")

  # Split content into up and down sections
  sections <- strsplit(content, "-- migrate:down", fixed = TRUE)[[1]]

  if (length(sections) != 2) {
    cli::cli_abort("Migration script {.file {migration_file}} must contain both up and down migrations.")
  }

  up_section <- sections[1]
  down_section <- sections[2]

  # Remove the '-- migrate:up' marker from up_section
  up_sql <- sub(".*-- migrate:up", "", up_section, perl = TRUE)

  # down_section already contains the SQL after '-- migrate:down'
  down_sql <- down_section

  list(
    up_sql = up_sql,
    down_sql = down_sql
  )
}
