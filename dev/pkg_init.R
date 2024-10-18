
#  ------------------------------------------------------------------------
#
# Title : migrate Package Initialization Script
#    By : Jimmy Briggs
#  Date : 2024-10-01
#
#  ------------------------------------------------------------------------

# libraries ---------------------------------------------------------------
require(devtools)
require(usethis)
require(roxygen2)
require(testthat)
require(rmarkdown)
require(knitr)
require(attachment)
require(pak)
require(purrr)
require(lifecycle)
require(rlang)
require(cli)
require(pkgload)
require(pkgbuild)
require(rcmdcheck)
require(fs)

# initialize --------------------------------------------------------------
if (FALSE) {
  usethis::create_package("migrate")
  usethis::use_git()
  usethis::use_namespace()
  usethis::use_roxygen_md()
  usethis::use_mit_license("Jimmy Briggs")
  usethis::use_readme_rmd()
  usethis::use_package_doc()
  usethis::use_import_from("rlang", ".data")
  usethis::use_import_from("rlang", ".env")
}

attachment::att_amend_desc()
devtools::document()


# setup dev directory -----------------------------------------------------
if (FALSE) {
  usethis::use_directory("dev", ignore = TRUE)
  fs::dir_create("dev/R")
}

# description -------------------------------------------------------------

if (FALSE) {
  usethis::use_description(
    fields = list(
      Title = "Database Migrations in R",
      Description = paste0(
        "Provides a database migration framework for R."
      ),
      Language =  "en-US"
    )
  )
}


# authors -----------------------------------------------------------------

if (FALSE) {

  usethis::use_author(
    "Jimmy",
    "Briggs",
    email = "jimmy.briggs@noclocks.dev",
    role = c("aut", "cre"),
    comment = c(ORCID = "0000-0002-7489-8787")
  )

  usethis::use_author(
    "Patrick",
    "Howard",
    email = "patrick.howard@noclocks.dev",
    role = c("aut", "rev")
  )

  usethis::use_author(
    "No Clocks, LLC",
    email = "team@noclocks.dev",
    role = c("cph", "fnd")
  )

}


# initial docs ------------------------------------------------------------

if (FALSE) {
  usethis::use_readme_rmd(open = FALSE)
  usethis::use_vignette("migrate")
}


# logo --------------------------------------------------------------------

usethis::use_logo("man/figures/noclocks-icon-dark.png")

# git & github ------------------------------------------------------------
usethis::use_git()
usethis::use_github()
usethis::use_github_links()

# testing ----------------------------------------------------------------
usethis::use_testthat(edition = 3, parallel = TRUE)

# code coverage
usethis::use_coverage(type = "codecov", repo_spec = "jimbrig/migrate")
usethis::use_covr_ignore("dev/")
usethis::use_covr_ignore("inst/")
usethis::use_covr_ignore("data-raw")
usethis::use_build_ignore("codecov.yml")
usethis::use_build_ignore(".covrignore")

# initial tests
usethis::use_test("migrate")

# # httptest2
# httptest2::use_httptest2()
#
# # shinytest2
# shinytest2::use_shinytest2()

# spellcheck
usethis::use_spell_check()
cat(
  "if (requireNamespace(\"spelling\", quietly = TRUE)) {",
  "  spelling::spell_check_test(",
  "    vignettes = TRUE,",
  "    error = FALSE,",
  "    skip_on_cran = TRUE",
  "  )",
  "}",
  "",
  file = "tests/spelling.R",
  sep = "\n",
  append = FALSE
)
spelling::update_wordlist()

# run tests
devtools::test()

# linting -----------------------------------------------------------------
lintr::use_lintr()
cat(
  "linters: linters_with_defaults(",
  "    line_length_linter(120),",
  "    commented_code_linter = NULL,",
  "    trailing_blank_lines_linter = NULL",
  "  )",
  "exclusions: list()",
  "encoding: \"UTF-8\"",
  "",
  file = ".lintr",
  sep = "\n",
  append = FALSE
)
usethis::use_build_ignore(".lintr")
lintr::lint_package()

# gitignore, gitattributes, editorconfig ----------------------------------

# fs::file_create(".gitignore")
fs::file_create(".gitattributes")
fs::file_create(".editorconfig")
usethis::use_build_ignore(".gitattributes")
usethis::use_build_ignore(".editorconfig")

# codemeta ----------------------------------------------------------------
# codemetar::write_codemeta()
codemeta::write_codemeta()
usethis::use_build_ignore("codemeta.json")

# news --------------------------------------------------------------------
usethis::use_news_md()

# github actions ----------------------------------------------------------

usethis::use_github_action(
  name = "document",
  save_as = "roxygen.yml",
  badge = TRUE
)

usethis::use_github_action(
  name = "lint",
  save_as = "lint.yml",
  badge = TRUE
)

usethis::use_github_action(
  name = "pr-commands",
  save_as = "pull-requests.yml",
  badge = TRUE
)

usethis::use_github_action(
  name = "style",
  save_as = "style.yml",
  badge = TRUE
)

usethis::use_github_action(
  name = "test-coverage",
  save_as = "coverage.yml",
  badge = TRUE
)

usethis::use_github_action(
  name = "check-standard",
  save_as = "check.yml",
  badge = TRUE
)

fs::file_create(".github/workflows/changelog.yml")
fs::file_create("CHANGELOG.md")
usethis::use_build_ignore("CHANGELOG.md")

# pkgdown -----------------------------------------------------------------

usethis::use_pkgdown_github_pages()

# inst --------------------------------------------------------------------
c(
  "inst",

  # migrations
  "inst/migrations",

  # templates
  "inst/templates",

  # config
  "inst/config",

  # extdata
  "inst/extdata",

  # scripts
  "inst/scripts"


) |>
  purrr::walk(fs::dir_create)

# config ------------------------------------------------------------------

require(noclocksr)

cfg_init <- list(
  "default" = list(
    "api" = list(
      "base_url" = "https://auth-api-dev.noclocks.dev",
      "version" = "v1",
      "api_key" = ""
    ),
    "db" = list(
      "adapter" = "postgresql",
      "host" = "localhost",
      "port" = 5432,
      "dbname" = "noclocksauth",
      "user" = "noclocksauth",
      "password" = "",
      "uri" = ""
    ),
    "email" = list(
      "provider" = "resend",
      "api_key" = "",
      "smtp_host" = "",
      "smtp_port" = 587,
      "smtp_user" = "",
      "smtp_password" = ""
    )
  )
)

noclocksr::cfg_init(cfg = cfg_init, overwrite = TRUE)
noclocksr::cfg_hooks_init()
usethis::use_build_ignore("config.yml")

# data --------------------------------------------------------------------

usethis::use_data_raw("internal")


# refresh -----------------------------------------------------------------

attachment::att_amend_desc()
devtools::document()
devtools::load_all()
devtools::check()
devtools::test()
devtools::install()
devtools::build()


