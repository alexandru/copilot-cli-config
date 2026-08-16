# My Copilot CLI configuration

The layout and skill content are ported from [alexandru/opencode-config](https://github.com/alexandru/opencode-config)

## Installation

**1)** Clone the repository and point `COPILOT_HOME` at the clone:

```sh
git clone https://github.com/alexandru/copilot-cli-config.git ~/.copilot

# If the path isn't standard, you may need to set this in your 
# ~/.zshrc, ~/.bashrc or ~/.profile
export COPILOT_HOME=/absolute/path/to/copilot-cli-config
```

**2)** Define this alias, also in `~/.zshrc`, `~/.bashrc` or `~/.profile`:

```bash
alias copilot='command copilot --agent Orchestrator'
```

The point is to choose a default agent from which to start, and `Orchestrator` should be that default.

**3)** Choose a model preset before first use and whenever you want to switch profiles:

```sh
./bin/copilot-switch work
# or
./bin/copilot-switch personal
# or, use automatic model selection for Orchestrator
./bin/copilot-switch work-auto
./bin/copilot-switch personal-auto
```

**WARN:** must run `copilot-switch` at least once, otherwise `settings.json` is missing. The switcher generates `settings.json` from:
- `settings.common.jsonc`
- `settings.presets.jsonc`

Both JSONC inputs support comments.

## Defined agents

Main agents:

- `Orchestrator`: implements changes; delegates evidence, research, and checks.

Sub-agents:

- `Junior`: bounded execution and shell-assisted exploration.
- `Explorer`: read-only codebase evidence gathering.
- `Librarian`: read-only external documentation and dependency-source research.

## Defined commands

- `/plan-implementation`: prepare a detailed implementation plan and save it as a Markdown specification file.
- `/grill-me`: stress-test a plan or decision.
- `/handoff`: prepare context for another agent or session.

## Defined skills

- `cellar`: query the APIs of JVM dependencies (Scala, Java).
- `codebase-design`: deep-module design vocabulary and principles.
- `domain-modeling`: domain language and architectural decisions.
- `diagnosing-bugs`: disciplined diagnosis for hard bugs and regressions.
- `tdd`: test-first development guidance.
- `grilling`: structured decision-tree interviews.
- `resolving-merge-conflicts`: merge and rebase conflict resolution.
- `simplify`: behavior-preserving code cleanup.

### Cellar

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

Install [Cellar](https://github.com/VirtusLab/cellar) for JVM dependency API lookup:

```sh
cs install --contrib cellar
cellar --version

# Disable telemetry
cellar telemetry disable
```

## Updating Skills

```
make update-skills
```
