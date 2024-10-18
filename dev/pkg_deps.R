
#  ------------------------------------------------------------------------
#
# Title : migrate Package Dependencies
#    By : Jimmy Briggs
#  Date : 2024-10-16
#
#  ------------------------------------------------------------------------

# libraries ---------------------------------------------------------------
c(
  "optparse",
  "DBI",
  "RPostgres",
  "config",
  "fs"
) |>
  purrr::walk(usethis::use_package)
