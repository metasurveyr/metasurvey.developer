# Migración: metasurvey.developer

Kit de desarrollo del ecosistema metasurvey, parte de la modularización sugerida por la
revisión de rOpenSci. Ver `RFC-MODULARIZACION.md` en el repo
[`metasurvey-legacy`](https://github.com/metasurveyr/metasurvey-legacy).

Responsabilidad: herramientas para desarrollar y extender el ecosistema. NO es
dependencia de runtime de ningún otro paquete.

## Contenido

| Qué | Origen |
|---|---|
| `inst/claude/agents/*.md` (5) | `metasurvey-legacy/.claude/agents/` (code-reviewer, cran-reviewer, doc-auditor, devops, test-engineer) |
| `inst/claude/commands/*.md` (8) | `metasurvey-legacy/.claude/commands/` (smart-commit, dev, check, create-pr, dplyr-ux, product-owner, r-expert, ropensci-prep) |
| `inst/scripts/` | `transpile_iecon_all.R`, `seed_anda_metadata.R`, `README.md` (scripts de dev/batch) |
| `R/claude-assets.R` | **nuevo** — `list_dev_assets()`, `use_metasurvey_dev_kit()` para instalar los agentes/commands en el `.claude/` de un proyecto |
| `R/scaffold.R` | **nuevo** — `create_recipe_skeleton()`, `create_backend_skeleton()` (generadores) |

## No migrado (a propósito)

- `.claude/settings.local.json` del legacy: tenía una **ruta local hardcodeada**
  (`/Users/.../tfg/metasurvey`) y permisos personales; no es un asset compartible, así
  que no se incluye.

## API

- `list_dev_assets("all"|"agents"|"commands")` — lista los agentes/commands incluidos.
- `use_metasurvey_dev_kit(path = ".", overwrite = FALSE)` — copia agentes + commands al
  `.claude/` del proyecto.
- `create_recipe_skeleton(name, survey_type, edition, path)` — script de recipe de arranque.
- `create_backend_skeleton(name, path)` — stub de un provider de backend que engancha en
  `options(metasurvey.backend_provider)`.

## Dependencias

- **Suggests**: `metasurvey.core` (los scaffolds generan código contra su API). No es dep
  de runtime.

R CMD check: 0 errors, 0 warnings, 0 notes. Tests: 17 pass.
