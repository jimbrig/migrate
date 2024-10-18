#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(optparse)
  library(migrate)
})

option_list <- list(
  make_option(c("-d", "--database"), type = "character", default = NULL,
              help = "Path to the database file", metavar = "character"),
  make_option(c("-u", "--update"), action = "store_true", default = FALSE,
              help = "Apply pending migrations"),
  make_option(c("-s", "--status"), action = "store_true", default = FALSE,
              help = "Show migration status"),
  make_option(c("-h", "--help"), action = "store_true", default = FALSE,
              help = "Show this help message and exit"),
  make_option(c("-r", "--rollback"), type = "integer", default = 1,
              help = "Number of migrations to roll back", metavar = "integer")
)

opt_parser <- OptionParser(usage = "usage: %prog [options]", option_list = option_list)
opt <- parse_args(opt_parser)

if (opt$help) {
  print_help(opt_parser)
  quit(status = 0)
}

if (is.null(opt$database)) {
  cat("Error: --database option is required.\n\n")
  print_help(opt_parser)
  quit(status = 1)
}

if (!is.null(opt$rollback)) {
  conn <- db_connect()
  on.exit(DBI::dbDisconnect(conn))
  rollback_migrations(conn, steps = opt$rollback)
}

# Set database path
options(migrate.db.path = opt$database)

# Execute commands based on options
if (opt$update) {
  migrate::update_database()
} else if (opt$status) {
  migrate::show_migration_status()
} else {
  cat("No action specified.\n\n")
  print_help(opt_parser)
}
