# Ver RFC-MODULARIZACION.md · paquete metasurvey.developer

test_that("list_dev_assets lists bundled agents and commands", {
  df <- list_dev_assets("all")
  expect_s3_class(df, "data.frame")
  expect_true(all(c("type", "name") %in% names(df)))
  expect_true(any(df$type == "agents"))
  expect_true(any(df$type == "commands"))
  expect_true("code-reviewer" %in% df$name)
  expect_true("smart-commit" %in% df$name)
})

test_that("use_metasurvey_dev_kit copies assets into .claude", {
  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  written <- use_metasurvey_dev_kit(path = tmp)
  expect_true(length(written) > 10)
  expect_true(dir.exists(file.path(tmp, ".claude", "agents")))
  expect_true(dir.exists(file.path(tmp, ".claude", "commands")))
  expect_true(file.exists(file.path(tmp, ".claude", "agents", "code-reviewer.md")))
})

test_that("use_metasurvey_dev_kit skips existing files without overwrite", {
  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  use_metasurvey_dev_kit(path = tmp)
  # Second run without overwrite writes nothing new
  suppressMessages(w2 <- use_metasurvey_dev_kit(path = tmp))
  expect_length(w2, 0)
})

test_that("create_recipe_skeleton writes an editable script", {
  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  f <- create_recipe_skeleton("employment",
    survey_type = "ech",
    edition = "2023", path = tmp, open = FALSE
  )
  expect_true(file.exists(f))
  txt <- readLines(f)
  expect_true(any(grepl("steps_to_recipe", txt)))
  expect_true(any(grepl("ech", txt)))
})

test_that("create_backend_skeleton writes a provider stub", {
  tmp <- tempfile()
  dir.create(tmp)
  on.exit(unlink(tmp, recursive = TRUE), add = TRUE)

  f <- create_backend_skeleton("myregistry", path = tmp)
  expect_true(file.exists(f))
  txt <- readLines(f)
  expect_true(any(grepl("myregistry_provider", txt)))
  expect_true(any(grepl("backend_provider", txt)))
})
