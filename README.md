# My Copilot CLI configuration

Part of [alexandru/agents-config](https://github.com/alexandru/agents-config).

## Installation

<details>
<summary>STEP 1 — Clone the repository</summary>

```sh
git clone https://github.com/alexandru/copilot-cli-config.git ~/.copilot

# If the path isn't standard, you may need to set this in your 
# ~/.zshrc, ~/.bashrc or ~/.profile
export COPILOT_HOME=/absolute/path/to/copilot-cli-config
```
</details>

<details>
<summary>STEP 2 — Install the shared third-party skills globally</summary>

```sh
cd ~/.copilot
make install-skills
```

The skills are installed under `~/.agents/skills`, where Copilot CLI,
OpenCode, and Codex can share them. The Copilot-specific `/grill-me` and
`/plan-implementation` command adapters remain tracked in this repository.
</details>

<details>
<summary>STEP 3 — Configure Bash/Zsh</summary>

Some configurations can't be set in Copilot's files, so 
define this useful alias in `~/.zshrc`, `~/.bashrc` or `~/.profile`...
```bash
alias copilot='command copilot --agent Orchestrator --yolo'
```
</details>

<details>
<summary>STEP 4 — Choose a model preset</summary>

```sh
# Example:
./bin/copilot-switch work-auto
```

**WARN:** run `copilot-switch` at least once. The switcher generates `settings.json` and `mcp-config.json` from:

- `settings.common.jsonc`
- `mcp-config.common.jsonc`
- `config.presets.jsonc`

All three JSONC inputs support comments.
</details>

<details>
<summary>STEP 5 — (optional) Install Cellar</summary>

[Cellar](https://github.com/VirtusLab/cellar) is useful for JVM dependency API lookup, and this repo's [Makefile](./Makefile) also installs its associated skill.

Install [Coursier](https://get-coursier.io/docs/cli-installation) first:

```sh
## MacOS
brew install coursier/formulas/coursier
cs setup

## Linux x86-64 (aka AMD64)
curl -fL "https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz" | gzip -d > cs

## Linux ARM64
curl -fL "https://github.com/VirtusLab/coursier-m1/releases/latest/download/cs-aarch64-pc-linux.gz" | gzip -d > cs
```

Then install Cellar via Coursier:

```sh
cs install --contrib cellar
cellar --version

# Disable telemetry
cellar telemetry disable
```
</details>

## Defined agents

Main agents:

- `Orchestrator` (default agent): implements changes; delegates evidence, research, and checks.

Sub-agents:

- `Junior`: bounded execution, mechanical work.
- `Explorer`: read-only codebase evidence gathering.
- `Librarian`: read-only external documentation and dependency-source research.

## Defined commands

Commands use currently selected primary agent and do not override it.

- `/plan-implementation`: prepare a detailed implementation plan and save it as a Markdown specification file.
- `/grill-me`: stress-test a plan or decision.
- `/handoff`: prepare context for another agent or session.

## Shared skills

- [alexandru/skills](https://github.com/alexandru/skills/)
  - `code-review`: review changed code for bugs, structural problems, performance issues, and unintended behavior.
  - `simplify`: behavior-preserving code cleanup.
- [mattpocock/skills](https://github.com/mattpocock/skills/tree/v1.2.3)
  - `codebase-design`: deep-module design vocabulary and principles.
  - `diagnosing-bugs`: disciplined diagnosis for hard bugs and regressions.
  - `domain-modeling`: domain language and architectural decisions.
  - `grill-with-docs`: sharpen a plan or design while creating domain documentation.
  - `grilling`: structured decision-tree interviews.
  - `handoff`: prepare context for another agent or session.
  - `implement`: implement work from a specification or set of tickets.
  - `improve-codebase-architecture`: find and work through codebase architecture improvements.
  - `resolving-merge-conflicts`: merge and rebase conflict resolution.
  - `setup-matt-pocock-skills`: configure a repository for the engineering skills.
  - `tdd`: test-first development guidance.
  - `to-spec`: turn the current conversation into a published specification.
  - `to-tickets`: break a plan or specification into tracer-bullet tickets.
- [VirtusLab/cellar](https://github.com/VirtusLab/cellar/)
  - `cellar`: query the APIs of JVM dependencies (Scala, Java).
- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)
  - `caveman`: token-efficient response modes with preserved technical accuracy.
- [cursor/plugins](https://github.com/cursor/plugins/tree/main/pstack/skills/unslop)
  - `unslop`: remove AI writing patterns and add a human voice.

## Updating shared skills

```sh
make update-skills
```

This reinstalls the configured global skill roster from its upstream sources.
