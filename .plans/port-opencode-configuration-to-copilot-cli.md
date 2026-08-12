# Port OpenCode Configuration to Copilot CLI

## Overview

Create a version-controlled GitHub Copilot CLI home that preserves the useful parts of `alexandru/opencode-config`: reusable skills, focused agents, planning and review workflows, model routing, and Kotlin language-server support. It must work when the repository is selected through `COPILOT_HOME`; OpenCode-only presets, request-header plugin, and MCP configuration are intentionally excluded.

## Current Context

- Target repository has only `.gitignore`, which currently ignores a local `opencode.jsonc` reference file. It has no instructions, validation tooling, or documentation.
- Source configuration is `https://github.com/alexandru/opencode-config` at `499dcfc21f38c3ee0fcb8ea34d4fd3dab4af8ecc`. It contains six agents, four commands, ten vendored skills, a lock manifest, Kotlin LSP setup, OpenCode model presets, optional MCP servers, and an OpenCode provider-header plugin.
- Copilot CLI supports user-scoped configuration under `$COPILOT_HOME`, custom agents in `agents/`, skills in `skills/`, `settings.json`, and `lsp-config.json`. User-defined direct slash commands are implemented as user-invocable skills, not agent profiles.
- Copilot built-ins already cover source `explore`, `scout`, and command execution: `explore`, `research`, and `task` use `claude-haiku-4.5`. Built-in-name override behavior is undocumented, so no custom profile uses those names.
- Repository owner selected `gpt-5.3-codex` for primary work and `claude-haiku-4.5` for custom subagents. Organization policy disables MCP; no MCP files or setup instructions will be created.

## Architecture / Design

- Treat the repository root as a portable `$COPILOT_HOME`, not as a project-specific `.github/` customization. `settings.json`, `agents/`, `skills/`, and `lsp-config.json` therefore apply across repositories.
- Set global primary model in `settings.json` to `gpt-5.3-codex`. Set `model: claude-haiku-4.5` only on custom `general` and `ask` agents; retain Copilot built-in `explore`, `research`, and `task` for cheap parallel evidence, external research, and command loops. Do not use `auto`, because CLI ignores custom-agent model fields when session model is Auto.
- Port behavior, not OpenCode permission syntax. Agents receive only tools required by their role where Copilot has comparable categories, and prompts state non-modification requirements. Do not add policy hooks: their platform-specific shell execution is more brittle than source behavior requires.
- Vendor all ten source skills verbatim except add/normalize Copilot-required `name` and `description` YAML frontmatter where absent. Keep supporting Markdown and script resources with relative links intact. Preserve upstream provenance in `skills-lock.json`; use a documented `Makefile` update procedure rather than automatic synchronization.
- Expose `/plan-implementation` and `/grill-me` as user-invocable skills. Use built-in `/review`, `/security-review`, `/research`, and `/plan` rather than duplicating source review command or colliding with built-in slash commands.
- Preserve Kotlin support using `lsp-config.json` and document required `kotlin-language-server` installation. It is active whenever executable is available; Copilot has no documented per-server `enabled` field.

## Implementation Steps

### Phase 1 — Home layout and primary behavior

1. **S — Replace target-specific ignore rule and add root documentation.** Update `.gitignore` to retain only local Copilot state that must never be committed; remove obsolete `opencode.jsonc` ignore. Add `README.md` describing `COPILOT_HOME` activation, shell setup, model behavior, supported built-ins, skill update process, LSP prerequisite, and explicit omissions (presets, MCP, OpenCode plugin, exact permission parity).
2. **S — Create `settings.json`.** Set default model to `gpt-5.3-codex`. Avoid unverified settings keys and do not configure MCP, permissions, hooks, or auto-update behavior.
3. **S — Create `lsp-config.json`.** Define unique `kotlin` server: `command: "kotlin-language-server"`, no arguments, and `fileExtensions` for `.kt` and `.kts` mapped to `kotlin`. Document `/lsp test kotlin`, `/lsp show`, and `copilot plugins list --kind lsp` validation.
4. **M — Create `agents/build.agent.md`, `agents/plan.agent.md`, `agents/ask.agent.md`, and `agents/general.agent.md`.** Use supported CLI frontmatter (`description`, `tools`, `model`, `disable-model-invocation`, `user-invocable`). Map source roles: build has primary implementation/delegation contract and TDD expectation; plan creates implementation plans and may write only plan artifacts by instruction; ask is response/research-only; general performs bounded, delegated mechanical work. Keep prompts clear that main agent retains diagnosis, design judgment, and code review. Configure Haiku only for `ask` and `general`; configure Gpt for build and plan. Do not create custom `explore` or `scout` profiles; document their built-in equivalents.

### Phase 2 — Workflows and skills

5. **M — Add `skills/plan-implementation/SKILL.md`.** Make it user-invocable as `/plan-implementation`; port source plan command requirements: inspect before questions, grill only for material uncertainty, plan summary format, S/M/L estimates, required saved `.plans/<kebab-name>.md` template, and final build handoff. State it should use built-in plan safety or custom plan agent for research, then write an approved repository plan.
6. **S — Add `skills/grill-me/SKILL.md`.** Make it user-invocable as `/grill-me`; contain a small wrapper that invokes the vendored `grilling` process for supplied topic while preserving its decision-tree, round-based question format.
7. **L — Vendor source skills under `skills/`.** Copy `caveman`, `cellar`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grilling`, `handoff`, `resolving-merge-conflicts`, `simplify`, and `tdd` including referenced resources/scripts. Normalize each `SKILL.md` frontmatter for Copilot required fields without changing body guidance. Remove OpenCode-specific `agents/openai.yaml` metadata because Copilot does not consume it. Preserve file-relative links and do not pre-approve shell tools.
8. **S — Add maintenance metadata.** Copy `skills-lock.json`, adapting only its explanatory metadata if necessary. Add `Makefile` target(s) that show the exact source update commands or a checked-in verification/update script. Keep update manual and reviewable; do not introduce npm dependencies solely for configuration.

### Phase 3 — Validation and onboarding

9. **M — Add configuration tests or validator.** Create a dependency-free test script (Node standard library) that parses JSON files, checks required agent and skill frontmatter, verifies all locked skills and required resources exist, rejects an MCP config, verifies intended models/tool categories, and checks README deployment notes. Add `package.json` with `npm test` only if Node is selected for this validator; otherwise use an equally portable built-in implementation.
10. **S — Run runtime discovery checks.** With `COPILOT_HOME` set to repository path, run `copilot plugins list`, `copilot skill list`, and inspect skills. Start interactive session to confirm custom agents appear through `/agent` and user-invocable skills through `/skills`; use `/lsp test kotlin` only when Kotlin language server is installed. Record commands and expected outcomes in README.

## Testing Strategy

- Run static validation after every configuration change: parse `settings.json` and `lsp-config.json`; check agent and skill frontmatter, names, descriptions, model assignments, required source resources, lock manifest, and no MCP configuration files.
- Run `copilot plugins list --scope user --json` and `copilot skill list` with `COPILOT_HOME` set to clone path; verify ten vendored and two workflow skills are discovered.
- In an interactive session, verify `/agent` lists build, plan, ask, and general; verify `/plan-implementation` and `/grill-me` appear in skills; verify built-in `/explore`, `/research`, `/task`, `/review`, and `/plan` remain available through their documented paths.
- If `kotlin-language-server` is installed, run `/lsp test kotlin`; otherwise validator confirms schema and README calls out prerequisite.

## Risks & Mitigations

- **CLI version/model availability changes:** `gpt-5.3-codex` and `claude-haiku-4.5` availability is account- and version-dependent. Validate with `/model` after installation; retain model names only in documented fields.
- **Custom agent model semantics:** Per-agent models are ignored when session model is `auto`. Set explicit primary Gpt model and document not to switch to Auto when fixed routing matters.
- **Limited policy enforcement:** Tool categories cannot reproduce OpenCode command/path rules. Limit tool categories where meaningful, make non-modification directives explicit, and rely on Copilot approvals/plan mode rather than hooks.
- **Built-in collisions:** Built-in agent and slash-command overrides are undocumented. Do not define profiles named `explore`, `research`, `task`, or built-in commands.
- **LSP executable absent:** Copilot cannot start Kotlin server until it is installed. Document installation plus `/lsp test kotlin` failure diagnosis.
- **External skill drift:** Vendoring isolates installs but needs conscious updates. Retain lock sources and a manual, reviewable update target.
- **Organization MCP policy:** No MCP files are added, so configuration stays compliant.

## Success Criteria

- Clone becomes active Copilot home through `COPILOT_HOME` and documents activation clearly.
- Primary model is `gpt-5.3-codex`; custom cheap agents use `claude-haiku-4.5`; built-in Haiku roles replace source exploration/research/command subagents.
- Four custom agents, ten ported source skills, `/plan-implementation`, and `/grill-me` are valid and discoverable.
- Built-in plan and review functionality is documented rather than shadowed.
- Kotlin LSP configuration validates and works when server is installed.
- MCP, OpenCode presets, OpenCode plugin, and no-longer-applicable strict permission syntax are absent and documented as unsupported or intentionally excluded.
- Automated static validation passes; live Copilot discovery commands have documented expected results.

## Open Questions

- None for initial implementation. Verify live model availability and custom-agent discovery against installed Copilot CLI version during validation.
