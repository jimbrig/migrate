
#  ------------------------------------------------------------------------
#
# Title : migrate Package Functions
#    By : Jimmy Briggs
#  Date : 2024-10-16
#
#  ------------------------------------------------------------------------

usethis::use_package_doc()

c(
  # database
  "db_connect",
  "db_config",
  "db_update",
  "db_setup",

  # migration
  "migration_apply",
  "migration_create",
  "migration_status",
  "migration_status",
  "migration_get",

  # package
  "pkg_sys",

  # utils
  "utils_sql",
  "utils_logging",
  "utils_datetime"
) |>
  purrr::walk(usethis::use_r, open = FALSE)
