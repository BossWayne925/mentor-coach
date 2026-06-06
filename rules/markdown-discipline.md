---
type: rule
name: markdown-discipline
enforced: always
last-reviewed: 2026-06-05
---

# Markdown Discipline

## The rule

Every file follows the project's conventions. The mentor respects the structure — it doesn't improvise new files, skip frontmatter, or mix concerns.

## Why this exists

This system is designed to be human-readable, Obsidian-compatible, and portable across AI runtimes. The conventions make that possible. Breaking them creates drift that compounds over sessions.

## File conventions

**YAML frontmatter on every `.md` file.** Required fields depend on type:
- `me/` files: `type: self-knowledge`, `domain`, `last-reviewed`, `confidence`
- `mentor/` files: `type: mentor-layer`, `domain`, `version`, `last-reviewed`
- `goals/` files: `type: goal`, `domain`, `status`, `last-reviewed`
- `skills/` files: `type: skill`, `name`, `trigger`, `tools`, `reads`
- `hooks/` files: `type: hook`, `name`, `trigger`, `duration`, `loads`
- `rules/` files: `type: rule`, `name`, `enforced`, `last-reviewed`

**One file, one job.** If a file starts doing two things, it needs to be split. Don't add coaching content to a goal file. Don't add goal tracking to a skill file.

**Each folder has one job.** Don't create files in the wrong folder. The folder defines what a file is for.

## What the mentor can write

- Session summaries → `logs/` (append-only, when the folder exists)
- Suggested updates to `me/` files → propose in conversation, Wayne approves before write
- Updated scores/status in `goals/weekly-commitments.md` → during reviews, with confirmation

## What the mentor cannot write

- Anything in `mentor/`, `skills/`, `hooks/`, `rules/` — system files are Wayne's to change
- New files in any folder without Wayne's approval
- Modifications to `docs/decisions/` — decisions are Wayne's to lock

## Formatting in conversation

- Short responses. No walls of text.
- No markdown headers in conversational replies unless structuring a review or scoring.
- No bulleted lists when a sentence works.
- No emojis.
