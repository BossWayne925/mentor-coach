# Next Session — Start Here

> If you're Claude (or me) opening this repo fresh, read this file first. Then read the four files listed below in order. That gives full context in under two minutes.

## State as of 2026-06-05 (session 01)

**Project:** Folder-based AI mentor focused on identity transformation. v1 ships a single-arc, single-voice mentor; designed as the first vertical slice of a larger mentor OS (sibling arcs + 7-mode system come in v2).

**Phase:** Brainstorming. Foundation committed (git, content layer, decisions doc, README). **Section 1 (top-level architecture) and Section 3 (`me/` layer) are approved.** Sections 2, 4, 5 still to do.

## Read these four files in order

1. **`docs/decisions/DECISIONS.md`** — 8 locked architectural decisions. Do not re-litigate without explicit reopen.
2. **`content/build-journal.md`** — Session 01 entry has the full reasoning, tensions, and content seeds from today.
3. **`README.md`** — The folder layout and architecture principles.
4. **`inspiration/Your mentor should have a house arc.txt`** — Optional. The full house-archetype vision so you understand what v2 grows into.

## What's next (sections still to design)

- **Section 2: Methodology layer** — `mentor/methodology.md`, `mentor/tone.md`, `mentor/reference/*` (5 framework files). The integrated D method cashed out into specifics the mentor coaches from.
- **Section 3: `me/` layer** — 6 files capturing what the mentor knows about Wayne (current identity, becoming, values, weaknesses, triggers, history). This requires actual interview answers from Wayne.
- **Section 4: goals + skills + hooks** — active-arc, the 7 coaching moves, the daily-checkin and weekly-review hooks.
- **Section 5: `CLAUDE.md` + rules** — runtime entry, plus 3 rule files (coach-not-lecture, pushback-style, markdown-discipline).
- **Spec doc + writing-plans handoff** — once all sections approved, the design gets written to `docs/superpowers/specs/2026-06-05-mentor-coach-v1-design.md` and we transition to implementation planning.

## Open decisions waiting on Wayne

These three were flagged at the end of session 01 build journal and need answers before Section 2/4 can be fully designed:

1. Daily check-in cadence — morning + evening, or evening only?
2. ~~`me/values.md` shape~~ — **resolved in Decision #09:** split into `values-stated.md` + `values-lived.md`.
3. Should the mentor be allowed to refuse to engage if Wayne shows up dishonest? (My instinct: yes. Needs to live in `mentor/constitution.md`.)

## Conventions to follow next session

- **Commits:** `<scope>: <what>` with optional `Why:` and `Seed:` lines. Scopes: `arch:` `mentor:` `me:` `goals:` `skills:` `hooks:` `journal:` `clip:` `docs:`.
- **At end of every working session:** append a new entry to `content/build-journal.md` with YAML frontmatter (date, session #, arc, phase, tags, content-seeds count). Extract any clip-worthy lines into `content/clips.md`. Extract any video ideas into `content/ideas.md`.
- **Public figures stay invisible** — never name Hormozi, Goggins, Rohn, Clear, etc. in mentor identity/tone/rules. They are inspiration, not branding.
- **One file, one job.** If a file starts doing two things, split it.

## How to resume

Tell Claude: **"Read NEXT-SESSION.md and pick up where we left off."** That's enough.
