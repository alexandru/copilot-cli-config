# Manual, reviewable skill updates. Never run automatically (no CI, no hooks).

# Uses the same upstream sources as the source repository:
# https://github.com/alexandru/opencode-config (vendored at commit
# 499dcfc21f38c3ee0fcb8ea34d4fd3dab4af8ecc — see skills-lock.json).
#
# After running: review every change with `git diff`, then commit.

.PHONY: update-skills

update-skills:
	npx skills add https://github.com/alexandru/skills/ -y --skill \
		simplify
	npx skills add https://github.com/mattpocock/skills -y --skill \
		codebase-design \
		diagnosing-bugs \
		domain-modeling \
		grilling \
		handoff \
		resolving-merge-conflicts \
		tdd
	npx skills add https://github.com/VirtusLab/cellar/ -y
	@echo "---"
	@echo "Review with: git diff"
	@echo "Commit only after manual review."
