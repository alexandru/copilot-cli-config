# My Copilot CLI configuration

The layout and skill content are ported from [alexandru/opencode-config](https://github.com/alexandru/opencode-config)

## Installation

Clone the repository and point `COPILOT_HOME` at the clone:

```sh
git clone https://github.com/alexandru/copilot-cli-config.git ~/.copilot

# If the path isn't standard, you may need to set this in your 
# ~/.zshrc, ~/.bashrc or ~/.profile
export COPILOT_HOME=/absolute/path/to/copilot-cli-config
```

Also define this alias, also in `~/.zshrc`, `~/.bashrc` or `~/.profile`:

```bash
alias copilot='copilot --agent Builder'
```

The point is to choose a default agent from which to start, and `Builder` should be that default.

Choose a model preset before first use and whenever you want to switch profiles:

```sh
./bin/copilot-switch work
# or
./bin/copilot-switch personal
```

Stable settings live in `settings.common.json`; presets live in
`settings.presets.json`. The switcher deep-merges common settings with the selected
preset and generates `settings.json`; agent definitions stay unchanged. Presets may
inherit from multiple presets with `extends`. Arrays are replaced, objects are
merged recursively, and presets marked `common: true` are hidden from the list.
Model variants are represented by Copilot CLI's `effortLevel` setting.

## Main agents

- `Builder`: implements changes; delegates evidence, research, and checks.
- `Planner`: investigates and prepares implementation plans; read-only.
- `Guide`: answers from code and web; never edits or runs commands.
- `Worker`: bounded mechanical changes and check loops.
- `Explorer`: read-only codebase evidence gathering.
- `Scout`: read-only external documentation and dependency-source research.

## Commands

- `/agent`: choose `Builder`, `Planner`, or `Guide`.
- `/plan-implementation`: prepare an implementation plan without changing files.
- `/grill-me`: stress-test a plan or decision.
- Built-ins: `/plan`, `/review`, `/security-review`, `/rubber-duck`, `/research`, `/skills`, `/model`.

## Skills

- `caveman`: concise replies.
- `cellar`: JVM dependency APIs.
- `codebase-design`, `domain-modeling`: design vocabulary and domain terms.
- `diagnosing-bugs`, `tdd`: debugging and test-first work.
- `grilling`: decision-tree questions.
- `resolving-merge-conflicts`, `simplify`: conflict resolution and behavior-preserving cleanup.
- `handoff`: session handoff.

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
