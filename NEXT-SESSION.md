# Next Session — Start Here

> If you're Claude (or me) opening this repo fresh, read this file first. Then read the four files listed below in order. That gives full context in under two minutes.

## State as of 2026-06-05 (session 01)

**Project:** Folder-based AI mentor focused on identity transformation. v1 ships a single-arc, single-voice mentor; designed as the first vertical slice of a larger mentor OS (sibling arcs + 7-mode system come in v2).

**Phase:** Design complete. All 5 sections built. **Sections 1-5 approved.** Ready for first live session.

## Read these four files in order

1. **`docs/decisions/DECISIONS.md`** — 8 locked architectural decisions. Do not re-litigate without explicit reopen.
2. **`content/build-journal.md`** — Session 01 entry has the full reasoning, tensions, and content seeds from today.
3. **`README.md`** — The folder layout and architecture principles.
4. **`inspiration/Your mentor should have a house arc.txt`** — Optional. The full house-archetype vision so you understand what v2 grows into.

## What's next (sections still to design)

- ~~**Section 2: Methodology layer**~~ — **Done.** 3 files: `mentor/identity.md`, `mentor/methodology.md`, `mentor/tone.md`. No reference subfolder. Decision #10 locked.
- **Section 3: `me/` layer** — 6 files capturing what the mentor knows about Wayne (current identity, becoming, values, weaknesses, triggers, history). This requires actual interview answers from Wayne.
- ~~**Section 4: goals + skills + hooks**~~ — **Done.** 4 goal files, 7 skill files, 4 hook files. Decision #11 locked. Morning + evening check-in confirmed.
- ~~**Section 5: `CLAUDE.md` + rules**~~ — **Done.** 4 files: `CLAUDE.md` (runtime entry), `rules/coach-not-lecture.md`, `rules/pushback-style.md`, `rules/markdown-discipline.md`. Includes refusal escalation gradient (warning → refusal), skill routing disambiguation, and file permission model.
- **Spec doc + writing-plans handoff** — once all sections approved, the design gets written to `docs/superpowers/specs/2026-06-05-mentor-coach-v1-design.md` and we transition to implementation planning.

## Open decisions waiting on Wayne

These three were flagged at the end of session 01 build journal and need answers before Section 2/4 can be fully designed:

1. ~~Daily check-in cadence~~ — **Resolved in Decision #11:** morning + evening.
2. ~~`me/values.md` shape~~ — **resolved in Decision #09:** split into `values-stated.md` + `values-lived.md`.
3. ~~Should the mentor be allowed to refuse to engage if Wayne shows up dishonest?~~ — **Resolved in Decision #10:** Yes. Constitutional right in `mentor/identity.md`.

## Conventions to follow next session

- **Commits:** `<scope>: <what>` with optional `Why:` and `Seed:` lines. Scopes: `arch:` `mentor:` `me:` `goals:` `skills:` `hooks:` `journal:` `clip:` `docs:`.
- **At end of every working session:** append a new entry to `content/build-journal.md` with YAML frontmatter (date, session #, arc, phase, tags, content-seeds count). Extract any clip-worthy lines into `content/clips.md`. Extract any video ideas into `content/ideas.md`.
- **Public figures stay invisible** — never name Hormozi, Goggins, Rohn, Clear, etc. in mentor identity/tone/rules. They are inspiration, not branding.
- **One file, one job.** If a file starts doing two things, split it.

## How to resume

Tell Claude: **"Read NEXT-SESSION.md and pick up where we left off."** That's enough.
