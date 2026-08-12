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
alias copilot=`copilot --agent build`
```

## Main agents

- `build`: implements changes; delegates evidence, research, and checks.
- `plan`: investigates then writes only `.plans/` documents.
- `ask`: answers from code and web; never edits or runs commands.
- `explore`: codebase facts. `research`: external sources (`gpt-5.3-codex`). `task`: commands, tests, lint.
- `general`: bounded mechanical changes and check loops.

## Commands

- `/agent`: choose `build`, `plan`, or `ask`.
- `/plan-implementation`: create and save an implementation plan.
- `/grill-me`: stress-test a plan or decision.
- Built-ins: `/plan`, `/review`, `/security-review`, `/rubber-duck`, `/research`, `/skills`, `/model`.

## Skills

- `caveman`: concise replies.
- `cellar`: JVM dependency APIs.
- `codebase-design`, `domain-modeling`: design vocabulary and domain terms.
- `diagnosing-bugs`, `tdd`: debugging and test-first work.
- `grilling`: decision-tree questions.
- `resolving-merge-conflicts`, `simplify`: conflict resolution and behavior-preserving cleanup.
- `handoff`: session handoff; not directly invocable.

## Updating Skills

```
make update-skills
```
