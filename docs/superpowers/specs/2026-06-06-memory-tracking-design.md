# Memory & Tracking System — Design Spec

**Date:** 2026-06-06  
**Status:** Approved  
**Author:** Wayne Douglas

---

## Problem

The mentor has no memory between sessions. Every day score, honest moment, and commitment result disappears when the conversation closes. The mentor starts every session with no evidence of what actually happened — making pattern recognition, accountability, and continuity impossible.

## Goals

1. Morning check-in: mentor walks in knowing yesterday's score and carry-forward
2. Weekly review: full week of scores and commitment completion visible without reconstruction
3. Pattern recognition: mentor can name recurring patterns over time (days, weeks)

---

## Architecture

Three file types. Three jobs. No overlap.

```
logs/
  sessions/
    YYYY-MM-DD-morning.md        # drafted by mentor, approved by Wayne
    YYYY-MM-DD-evening.md        # drafted by mentor, approved by Wayne
    YYYY-MM-DD-freeform.md       # drafted by mentor, approved by Wayne
    YYYY-MM-DD-weekly-review.md  # drafted by mentor, approved by Wayne
  weeks/
    YYYY-WNN.md              # generated when weekly-review session log is saved
  tracker.md                 # always computed by script, never manually edited
scripts/
  update-tracker.ps1         # reads session logs, writes tracker.md + weekly summaries
```

### Rules

- Session logs are append-only. The mentor never edits a closed session log.
- `tracker.md` is always derived from session logs. Never manually edited.
- Weekly summaries are generated once during weekly review and then closed.
- The mentor reads `tracker.md` first at every session start.

---

## Session Log Schemas

### Morning log

```markdown
---
date: YYYY-MM-DD
type: morning
top-3-tasks: ["task 1", "task 2", "task 3"]
carry-forward: ["item from yesterday"]
energy: high | medium | low
---

## Plan for today

[What the mentor and Wayne locked in. Specific, not vague.]

## Carry-forward from last night

[What came in from yesterday's evening log.]

## If-then activations

[Any pre-loaded responses Wayne named for today's likely friction points.]
```

### Evening log

```markdown
---
date: YYYY-MM-DD
type: evening
score: becoming | mixed | comfort-zone-won
top-3-planned: ["task 1", "task 2", "task 3"]
top-3-done: ["task 1", "task 2"]
commitments-touched: [1, 3]    # 1-based indices into goals/weekly-commitments.md
slip: true | false
skills-deployed: [score-the-day]
---

## The 3 things

[What Wayne named. What each voted for.]

## Score rationale

[One or two sentences on why the score is what it is.]

## Hard question

[What came up — avoidance, slips, honest moments.]

## Values check

[Were actions aligned with stated values? Any pattern worth noting?]

## Carry-forward

[Anything that needs to show up in tomorrow's morning check-in.]
```

### Freeform log

```markdown
---
date: YYYY-MM-DD
type: freeform
topic: "one-line description of what was worked on"
skills-deployed: []
carry-forward: []
---

## What we worked on

[Topic, context, what was explored or decided.]

## Key moments

[Anything the mentor would want to remember — a realization, a commitment made, a pattern named.]

## Carry-forward

[Anything that needs to show up at the next check-in or weekly review.]
```

---

## Tracker Schema (`logs/tracker.md`)

Fully computed by `scripts/update-tracker.ps1`. Never manually edited.

```markdown
---
generated: YYYY-MM-DDTHH:MM:SS
sessions-logged: N
---

# Tracker

## Current streak
Becoming: N days
Last comfort-zone-won: YYYY-MM-DD

## This week (WNN)
| Day | Morning | Evening | Score |
|-----|---------|---------|-------|
| Mon | logged  | logged  | becoming |
| Tue | logged  | logged  | mixed |

## Weekly commitments (WNN)
1. [ ] Commitment text
2. [x] Commitment text

Completion: N/5 (N%)

## Plan vs. done (last 7 days)
Tasks planned: N | Tasks done: N | Hit rate: N%

## Patterns flagged
- [auto-generated from session data]
```

---

## Hook Wiring

A `PostToolUse` hook in `.claude/settings.json` watches for writes to `logs/sessions/`. When the mentor saves an approved session log, the hook fires `scripts/update-tracker.ps1` automatically.

### Script responsibilities

1. Read YAML frontmatter from all `logs/sessions/*.md` files
2. Compute: streak, weekly scores, plan-vs-done hit rate, commitment completion %
3. Flag patterns: comfort-zone-won streaks, lowest-scoring day of week, plan-vs-done gap
4. Regenerate `logs/tracker.md`
5. If session type is `weekly-review`: regenerate `logs/weeks/YYYY-WNN.md`. Also reads `goals/weekly-commitments.md` to resolve commitment indices to text.

No manual step required. Wayne approves the session log → it saves → tracker updates.

---

## Mentor Workflow

### Session start (every session)

Load in order:
1. `logs/tracker.md` — current state, streak, patterns (always)
2. Most recent session log — carry-forward and full context (always)
3. Session-type hook file — `hooks/morning-checkin.md` or `hooks/evening-checkin.md`
4. Relevant `me/` and `goals/` files per CLAUDE.md routing

### Session end (every session)

1. Mentor drafts the session log (morning or evening schema)
2. Presents to Wayne: *"Here's the session summary. Does this capture it accurately?"*
3. Wayne approves or requests edits
4. Mentor writes the file → PostToolUse hook fires → `update-tracker.ps1` runs → `tracker.md` regenerates

---

## Weekly Summary (`logs/weeks/YYYY-WNN.md`)

Generated automatically when a `weekly-review` session log is saved. Contains:

- Week score record (Mon–Sun)
- Commitment completion: pass/fail per item with notes
- Plan-vs-done hit rate for the week
- Top pattern from the week
- Carry-forward into next week's commitments

---

## What This Enables

- **Morning check-in:** Mentor reads tracker.md + last evening log. Knows the score, carry-forward, and current streak before Wayne says a word.
- **Weekly review:** `logs/weeks/YYYY-WNN.md` is the complete record. No reconstruction from memory.
- **Pattern recognition:** Tracker flags recurring patterns computed from session frontmatter. Mentor can say "comfort zone won 4 of the last 7 evenings — what's the pattern?" with evidence.

---

## Out of Scope

- No database, no external service, no dashboard UI
- No automated session log generation — mentor always drafts, Wayne always approves
- No modification of existing `mentor/`, `skills/`, `hooks/`, or `rules/` files
