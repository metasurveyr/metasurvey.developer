# Ver RFC-MODULARIZACION.md · paquete metasurvey.developer
# Generadores de scaffolding para extender el ecosistema metasurvey.

#' Scaffold a new recipe script
#'
#' Writes a starter R script that builds a metasurvey recipe with a couple of
#' example steps, ready to edit. Useful when contributing recipes to the
#' registry.
#'
#' @param name Recipe name (also used for the file name).
#' @param survey_type Survey type the recipe targets (e.g. "ech").
#' @param edition Survey edition (e.g. "2023").
#' @param path Directory to write the script into (default: current directory).
#' @param open Open the file after writing (interactive sessions only)?
#' @return Invisibly, the path to the written script.
#' @export
#' @examples
#' \dontrun{
#' create_recipe_skeleton("employment", survey_type = "ech", edition = "2023")
#' }
create_recipe_skeleton <- function(name,
                                   survey_type = "ech",
                                   edition = "2023",
                                   path = ".",
                                   open = interactive()) {
  stopifnot(is.character(name), length(name) == 1L, nzchar(name))
  file <- file.path(path, paste0("recipe-", .slug(name), ".R"))
  contents <- c(
    sprintf("# Recipe: %s (%s %s)", name, survey_type, edition),
    "# Scaffolded by metasurvey.developer::create_recipe_skeleton().",
    "",
    "library(metasurvey)",
    "",
    sprintf(
      'svy <- survey_empty(type = "%s", edition = "%s")',
      survey_type, edition
    ),
    "",
    "# --- Steps ------------------------------------------------------------------",
    "svy <- svy |>",
    "  step_recode(",
    '    "example_var",',
    "    condition_1 ~ 1,",
    "    condition_2 ~ 2,",
    "    .default = NA",
    "  ) |>",
    "  step_compute(example_derived = example_var * 2)",
    "",
    "# --- Package as a recipe ----------------------------------------------------",
    sprintf("recipe <- steps_to_recipe("),
    sprintf('  name = "%s",', name),
    '  user = "your_user",',
    "  svy = svy,",
    sprintf('  description = "TODO: describe the %s recipe",', name),
    "  steps = get_steps(svy)",
    ")",
    "",
    "recipe"
  )
  writeLines(contents, file)
  message("Wrote recipe skeleton: ", file)
  if (isTRUE(open) && requireNamespace("utils", quietly = TRUE)) {
    utils::file.edit(file)
  }
  invisible(file)
}

#' Scaffold a new recipe-backend implementation
#'
#' Writes a starter file for a custom backend that plugs into
#' `metasurvey.core`'s injectable backend hook
#' (`options(metasurvey.backend_provider = ...)`), the same mechanism
#' `metasurvey.explorer.backend` uses.
#'
#' @param name Backend name (used for the file name).
#' @param path Directory to write into (default: current directory).
#' @return Invisibly, the path to the written file.
#' @export
#' @examples
#' \dontrun{
#' create_backend_skeleton("myregistry")
#' }
create_backend_skeleton <- function(name, path = ".") {
  stopifnot(is.character(name), length(name) == 1L, nzchar(name))
  file <- file.path(path, paste0("backend-", .slug(name), ".R"))
  contents <- c(
    sprintf("# Custom metasurvey backend provider: %s", name),
    "# Scaffolded by metasurvey.developer::create_backend_skeleton().",
    "#",
    "# Register with:",
    sprintf("#   options(metasurvey.backend_provider = %s_provider)", .slug(name)),
    "# so that set_backend(\"api\") routes recipe/workflow operations here.",
    "",
    sprintf("%s_provider <- function(op, args) {", .slug(name)),
    "  switch(op,",
    "    list_recipes      = do.call(.list_recipes, args),",
    "    get_recipe        = do.call(.get_recipe, args),",
    "    publish_recipe    = do.call(.publish_recipe, args),",
    "    download_recipe   = do.call(.download_recipe, args),",
    "    list_workflows    = do.call(.list_workflows, args),",
    "    get_workflow      = do.call(.get_workflow, args),",
    "    publish_workflow  = do.call(.publish_workflow, args),",
    "    download_workflow = do.call(.download_workflow, args),",
    '    stop("Unknown backend op: ", op, call. = FALSE)',
    "  )",
    "}",
    "",
    "# TODO: implement the .list_recipes(), .get_recipe(), ... helpers."
  )
  writeLines(contents, file)
  message("Wrote backend skeleton: ", file)
  invisible(file)
}

# Internal: turn a human name into a file-safe slug.
.slug <- function(x) {
  x <- tolower(x)
  x <- gsub("[^a-z0-9]+", "_", x)
  gsub("^_|_$", "", x)
}
