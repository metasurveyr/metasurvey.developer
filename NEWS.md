# metasurvey.developer 0.1.0

* Initial release. Developer kit for extending the metasurvey ecosystem,
  assembled as part of the modularization suggested by the rOpenSci review. See
  `MIGRATION.md`.
* Bundles the ecosystem's Claude Code development agents (5) and slash commands
  (8), installable into a project with `use_metasurvey_dev_kit()`.
* Scaffolding generators: `create_recipe_skeleton()`,
  `create_backend_skeleton()`.
* `list_dev_assets()` lists the bundled agents and commands.
