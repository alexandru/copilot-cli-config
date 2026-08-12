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
alias copilot='copilot --agent build'
```

The point is to choose a default agent from which to start, and `build` should be that default.

## Main agents

- `build`: implements changes; delegates evidence, research, and checks.
- `plan`: investigates and prepares implementation plan; read-only.
- `ask`: answers from code and web; never edits or runs commands.
- `scout`: read-only external documentation and dependency-source research.
- Built-ins: `explore` for codebase facts and `task` for commands, tests, and lint.
- `general`: bounded mechanical changes and check loops.

## Commands

- `/agent`: choose `build`, `plan`, or `ask`.
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
