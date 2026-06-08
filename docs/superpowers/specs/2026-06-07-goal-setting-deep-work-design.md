---
date: 2026-06-07
topic: goal-setting and deep work planning sessions
status: approved
---

# Goal-Setting and Deep Work Planning Sessions

## Context

The mentor coach currently has three structured session types: morning check-in, evening check-in, and weekly review. Two gaps were identified:

1. No structured session for defining new goals or revising existing ones mid-week or mid-arc
2. No structured session for breaking down a specific project into tasks, or planning a focused workday

This spec adds both as Approach A: two new hook files following the existing session pattern.

## Architecture

```
hooks/
  goal-setting.md      ← new
  deep-work.md         ← new
projects/              ← new directory (standalone project breakdowns)
  .gitkeep
CLAUDE.md              ← routing table + file permissions updated
```

No changes to: mentor/, skills/, rules/, session log schema, update-tracker.ps1.

Both sessions write a `freeform` session log (existing type) with a `topic:` field identifying the session.

## Routing (CLAUDE.md additions)

| Wayne says | Hook | Also load |
|---|---|---|
| "goal setting", "new goal", "set a goal", "revise my goals", "kill a goal" | `hooks/goal-setting.md` | `goals/90-day-picture.md`, `goals/active-arc.md`, `goals/weekly-commitments.md`, `goals/if-then-plans.md`, `me/becoming.md` |
| "deep work", "break down [project]", "plan my work blocks", "planning session" | `hooks/deep-work.md` | `goals/weekly-commitments.md`, `goals/if-then-plans.md`, `TASKS.md` |

## Goal-Setting Hook

**Trigger:** "goal setting", "new goal", "set a goal", "revise my goals", "kill a goal"
**Duration:** 15-20 min
**Mentor mode:** Collaborative but identity-anchored. No refusal escalation. Still holds the becoming portrait and challenges anything that doesn't connect to it.

### Flow

**1. Orient (1 min)**
First question: new goal or revision?
- New → step 2
- Revision → load the specific goal, then step 2
- Kill a goal → name it, ask why, confirm it's dead, remove from `90-day-picture.md` with Wayne's approval, close

**2. Reality check (3 min)**
- "Read me the relevant part of your 90-day picture. Where does this fit?"
- "Is this replacing something, or adding to the pile?" — if adding: "You already have commitments. What does this displace?"
- "Is this coming from the becoming portrait, or something new that showed up this week?" — if new and shiny: "What does the man you're becoming need more — this, or what you already committed to?"

**3. Define done (3 min)**
No vague goals get written down.
- "What ships? What number? What date?"
- If Wayne says "get better at X" → "That's not done. What does done look like in 30 days?"
- Output: one sentence: "By [date], I have [specific thing]."

**4. Obstacle pre-load (3 min)**
Every goal gets a defense before it's written.
- "What's the most likely way this fails? Not 'life happens' — what's your specific failure mode?"
- "Build the if-then: IF [that thing happens], THEN [specific response]."
- Draft the if-then in conversation — do not write yet

**5. Wire it in (2 min)**
- Add to `goals/90-day-picture.md` under the right category — Wayne approves before write
- Add the drafted if-then to `goals/if-then-plans.md` — Wayne approves before write
- If it needs to be this week's work: suggest adding to `goals/weekly-commitments.md` — Wayne decides

**6. Close**
"It's in the system. You know what done looks like, you know what tries to stop you, and you have a plan for that. What's the first action?"

### File permissions
| File | Action |
|---|---|
| `goals/90-day-picture.md` | Add or remove targets — Wayne approves before write |
| `goals/if-then-plans.md` | Add new if-then — Wayne approves before write |
| `goals/weekly-commitments.md` | Suggest addition — Wayne decides |

## Deep Work Hook

**Trigger:** "deep work", "break down [project]", "plan my work blocks", "planning session"
**Duration:** 10-20 min (breakdown longer, block planning shorter)
**Sub-mode detection:** At session start: "What are we planning — a specific project breakdown, or today's work blocks?"

### Sub-mode A: Project breakdown (15-20 min)

**1. Define the project (2 min)**
- "Name it. What is it?"
- "What does done look like? One sentence — what ships?"
- "What's the deadline?" — if none: "Pick one. A goal without a date is a wish."

**2. Break into phases (3-4 min)**
- "Walk me through it top-down. 3-5 phases max — what are the major stages?"
- Mentor pushes back on phases that are actually tasks, and tasks that are actually projects
- "Which phase has the most unknown? That's the one we plan most carefully."

**3. Phase 1 into tasks (3-4 min)**
- Break phase 1 only into concrete tasks
- Each task: one action, one owner, completable in a single work block
- Goes into `TASKS.md` under a new section named after the project
- Mentor challenge: "Is that a task or a project inside a project?"

**4. Standalone project file (2 min)**
- Full breakdown (all phases, key decisions, definition of done) written to `projects/[project-name].md`
- `TASKS.md` gets phase 1 tasks only — keeps the board clean
- Both files require Wayne's approval before write

**5. Blocker pre-load (2 min)**
- "What's the most likely thing that stalls this project at the halfway point?"
- Build the if-then: IF [stall trigger], THEN [specific move]
- Adds to `goals/if-then-plans.md` with Wayne's approval

**6. Close**
"Phase 1 is in TASKS.md. You know what done looks like and what tries to stop you. What's the first task you're doing today?"

### Sub-mode B: Day block planning (10 min)

**1. Anchor to commitments (1 min)**
- "What's the most important thing you need to move today?" — must connect to weekly commitments
- If it doesn't: "That's not on your commitments list. What's more important — that or what you committed to this week?"

**2. Inventory the day (2 min)**
- "How many hours of real focused time do you have today?"
- "Any hard constraints — appointments, pickups, fixed obligations?"

**3. Block the time (3 min)**
- Structure: deep work block (when, what, duration), shallow work window, protected stop time
- "When is your best focus window today — morning, afternoon, evening?"
- "What goes in that window and nothing else?"

**4. Resistance pre-load (2 min)**
- "What's most likely to pull you off this plan today?"
- Build the specific if-then for today's biggest threat
- Does NOT write to `goals/if-then-plans.md` — this is a one-day plan, not a standing rule

**5. Commit (1 min)**
- "You have [X] hours, [Y] is the priority, and if [Z] happens you [response]. Are you in?"

### File permissions
| File | Action |
|---|---|
| `TASKS.md` | Add project section with phase 1 tasks — Wayne approves before write |
| `projects/[name].md` | Create standalone project breakdown — Wayne approves before write |
| `goals/if-then-plans.md` | Add project blocker if-then — Wayne approves before write (project breakdown only) |

## Session Logs

Both sessions end with a drafted `freeform` session log:

```yaml
---
date: YYYY-MM-DD
type: freeform
topic: "goal-setting: [goal name]"   # or "deep-work: [project name]" / "deep-work: day blocks"
carry-forward: []
---
```

The PostToolUse hook fires on write → tracker regenerates.

## What Does NOT Change

- `mentor/identity.md`, `mentor/methodology.md`, `mentor/tone.md` — untouched
- All 7 skill files — untouched
- `rules/` — untouched
- Session log schema — freeform type already exists
- `scripts/update-tracker.ps1` — already handles freeform logs
- Refusal protocol — applies in freeform sessions, not in goal-setting or deep work (different mode)
