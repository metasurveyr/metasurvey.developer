# Ver RFC-MODULARIZACION.md · paquete metasurvey.developer
# Instala los assets del harness (agentes y commands) en el proyecto del usuario.

#' List the bundled Claude agents and commands
#'
#' The package ships the metasurvey ecosystem's development agents and slash
#' commands (rOpenSci reviewer, CRAN reviewer, doc auditor, smart-commit, etc.).
#' This lists what is available.
#'
#' @param type One of `"agents"`, `"commands"`, or `"all"`.
#' @return A data.frame with columns `type` and `name`.
#' @export
#' @examples
#' list_dev_assets()
list_dev_assets <- function(type = c("all", "agents", "commands")) {
  type <- match.arg(type)
  kinds <- if (type == "all") c("agents", "commands") else type
  rows <- lapply(kinds, function(k) {
    dir <- system.file("claude", k, package = "metasurvey.developer")
    files <- if (dir == "") character(0) else list.files(dir, pattern = "\\.md$")
    if (length(files) == 0) {
      return(NULL)
    }
    data.frame(
      type = k,
      name = sub("\\.md$", "", files),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

#' Install the bundled Claude agents and commands into a project
#'
#' Copies the metasurvey development agents and slash commands into a
#' project's `.claude/` directory so they are available to Claude Code.
#'
#' @param path Project root directory (default: current working directory).
#' @param overwrite Overwrite existing files with the same name?
#' @param which One of `"all"`, `"agents"`, or `"commands"`.
#' @return Invisibly, the character vector of files written.
#' @export
#' @examples
#' \dontrun{
#' use_metasurvey_dev_kit()
#' }
use_metasurvey_dev_kit <- function(path = ".",
                                   overwrite = FALSE,
                                   which = c("all", "agents", "commands")) {
  which <- match.arg(which)
  kinds <- if (which == "all") c("agents", "commands") else which
  written <- character(0)
  for (k in kinds) {
    src_dir <- system.file("claude", k, package = "metasurvey.developer")
    if (src_dir == "") next
    dest_dir <- file.path(path, ".claude", k)
    dir.create(dest_dir, recursive = TRUE, showWarnings = FALSE)
    for (f in list.files(src_dir, pattern = "\\.md$", full.names = TRUE)) {
      dest <- file.path(dest_dir, basename(f))
      if (file.exists(dest) && !overwrite) {
        message("Skipping existing file (use overwrite = TRUE): ", dest)
        next
      }
      file.copy(f, dest, overwrite = overwrite)
      written <- c(written, dest)
    }
  }
  message("Installed ", length(written), " dev asset(s) into ", file.path(path, ".claude"))
  invisible(written)
}
