# copilot-cli-config

Version-controlled [GitHub Copilot CLI](https://github.com/github/copilot-cli) configuration, used as `COPILOT_HOME`. It provides custom agents, vendored skills, a Kotlin LSP server definition, and a default model — everything lives in this repository and is installed by pointing `COPILOT_HOME` at a clone.

The layout and skill content are ported from [alexandru/opencode-config](https://github.com/alexandru/opencode-config), vendored at commit `499dcfc21f38c3ee0fcb8ea34d4fd3dab4af8ecc` (see [Skills](#skills) and [Updating skills](#updating-skills) for provenance).

## Installation

Clone the repository and point `COPILOT_HOME` at the clone:

```sh
git clone https://github.com/<you>/copilot-cli-config.git
export COPILOT_HOME=/absolute/path/to/copilot-cli-config
```

Use the absolute path — Copilot CLI needs a stable location. To make the export persistent, append it to your shell's startup file (works for both bash and zsh):

```sh
# bash: ~/.bashrc  ·  zsh: ~/.zshrc
echo 'export COPILOT_HOME=/absolute/path/to/copilot-cli-config' >> ~/.bashrc
```

Then start a new shell (or `source ~/.bashrc` / `source ~/.zshrc`) and launch `copilot`.

**Restart sessions after config changes.** Agents, skills, and other configuration are read when a session starts. After changing anything in this repository, quit and start a new Copilot session (for example, exit the current session and run `copilot` again) so the changes take effect.

## Models

- `settings.json` sets the default model to `gpt-5.3-codex` for sessions that do not specify one.
- The `build`, `plan`, and `ask` agents use `gpt-5.3-codex`.
- The `general` agent uses `claude-haiku-4.5` — the fast, cheap model for bounded mechanical work.

## Agents

Copilot CLI ships built-in agents — `explore` (codebase evidence), `research` (external documentation and dependency research), and `task` (mechanical command/test/lint loops). This repository adds four custom profiles in `agents/`:

| Agent | Model | When to use |
|-------|-------|-------------|
| `build` | `gpt-5.3-codex` | Main implementation agent. Owns diagnosis, solution, architecture, and review judgment; delegates evidence to `explore`, external research to `research`, and command/test loops to `task`. |
| `plan` | `gpt-5.3-codex` | Planning only. Writes plans under `.plans/`; read-only everywhere else. Manually selected via `/agent` or `copilot --agent plan`. |
| `ask` | `gpt-5.3-codex` | Conversational questions and codebase discussion. Read-only: no edits, no shell. |
| `general` | `claude-haiku-4.5` | Bounded mechanical implementation/refactor/test/lint work supplied by the caller. Not user-invocable; the model may infer it. |

Mapping from the source repository: source `explore` maps to the built-in `explore` agent, and source `scout` maps to the built-in `research` agent.

## Skills

Vendored skills live under `skills/` (one directory per skill, each with `SKILL.md` and its supporting resources). The ten vendored skills are `caveman`, `cellar`, `codebase-design`, `diagnosing-bugs`, `domain-modeling`, `grilling`, `handoff`, `resolving-merge-conflicts`, `simplify`, and `tdd`. Their `SKILL.md` bodies are copied from the source repository without behavioral rewrites; the `agents/openai.yaml` files from the source are omitted because Copilot does not use them. `handoff` is shipped with `user-invocable: false` (it is not a slash command).

Two custom skills are added:

- `/plan-implementation` — presents a plan (Goal, Context, Approach with `S`/`M`/`L` estimates, Testing Strategy, Risks, Assumptions, Open questions) and saves it to `./.plans/<descriptive-kebab-case-name>.md` with the full eight-section template. Note that it requires normal execution mode to write under `.plans/`; the built-in `/plan` offers a protected private plan workspace instead.
- `/grill-me` — a relentless interview session that reproduces the vendored `grilling` procedure (decision tree, question rounds, recommended answers).

Copilot CLI built-ins are used as-is: `/plan`, `/review`, `/security-review`, and `/rubber-duck`. There is intentionally no custom `review` skill — use the built-in `/review`.

`skills-lock.json` is copied from the source repository. It records the original upstream state (source repo, skill path, and computed hash per skill) and is not managed by Copilot.

## Kotlin LSP

`lsp-config.json` registers the Kotlin language server:

```json
{
  "lspServers": {
    "kotlin": {
      "command": "kotlin-language-server",
      "args": [],
      "fileExtensions": { ".kt": "kotlin", ".kts": "kotlin" }
    }
  }
}
```

Prerequisite: `kotlin-language-server` must be installed and on `PATH` (it is not bundled here). Verify with `/lsp test kotlin` inside a Copilot session — a passing test reports the server connected for `.kt`/`.kts` files.

## Verifying installation

- `copilot plugins list --scope user --json` — should show no plugins (no MCP or OpenCode plugin is configured).
- `copilot skill list` — should list the installed skills.
- Inside a session: `/skills list` — shows available skills.
- Inside a session: `/agent` — shows the custom agents (`build`, `plan`, `ask`, `general`) alongside built-ins.

## Updating skills

Skill updates are manual and reviewable — never automatic:

```sh
make update-skills
```

This runs the same `npx skills add` commands against the same upstream sources used by the source repository. After it finishes, review every change with `git diff` and only then commit. `skills-lock.json` records the upstream state of the ten vendored skills at the ported commit (`499dcfc21f38c3ee0fcb8ea34d4fd3dab4af8ecc` of `alexandru/opencode-config`); re-lock it to the new state when you intentionally update.

## Intentional gaps

- **No presets** — the source repository's preset switching (`.oh-my-opencode-slim`/presets) is not ported.
- **No OpenCode request plugin** — this is a Copilot CLI configuration; the OpenCode request plugin is not used.
- **No MCP** — by organization policy, no MCP servers are configured anywhere in this repository.
- **Built-in GitHub MCP disabled** — `settings.json` disables `github-mcp-server`.
- **No exact command/path permission enforcement** — Copilot's base permissions are relaxed here; prompts and tool categories, together with Copilot's approval prompts, provide best-effort bounds rather than hard guarantees.
