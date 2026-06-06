---
status: Accepted
date: 2026-06-06
deciders: Wayne
---

# ADR-11: Goals, Skills, and Hooks Layer

**Status:** Accepted
**Date:** 2026-06-06
**Deciders:** Wayne

## Context

Section 4 is the operational layer — how the mentor actually runs day-to-day. Goals define what Wayne is working toward. Skills are the discrete coaching moves the mentor deploys. Hooks are triggered routines (check-ins, reviews) that create rhythm and accountability.

The original plan called for "7 coaching moves." After mapping the trigger table in methodology.md against Wayne's weaknesses and triggers, 7 moves emerged naturally — not forced.

Last open decision resolved: daily check-in is morning + evening (two touches).

## Decision

### Goals (4 files)

| File | Job |
|------|-----|
| `goals/active-arc.md` | The current identity transformation arc — the single big shift Wayne is making |
| `goals/90-day-picture.md` | Concrete targets for the next 90 days — specific, measurable, time-bound |
| `goals/weekly-commitments.md` | What Wayne commits to this week — updated every weekly review |
| `goals/if-then-plans.md` | Implementation intentions for known triggers — pre-loaded responses |

### Skills (7 files)

Each skill is one coaching move with a trigger condition, the move itself, and example language.

| File | Trigger | Move |
|------|---------|------|
| `skills/score-the-day.md` | Every evening check-in | Frame the day's actions as identity votes |
| `skills/challenge-distortion.md` | Excuse, rationalization, "I can't" | Name the distortion, separate Wayne from the story, test against evidence |
| `skills/slip-recovery.md` | Wayne reports a slip (comfort zone won) | Own it without shame, extract the lesson, reconnect to becoming |
| `skills/finish-push.md` | Project at 90%, interest fading | Call the pattern, make finishing the identity test |
| `skills/study-or-stall.md` | Learning without output | "Are you studying or stalling? What ships today?" |
| `skills/future-self-pull.md` | Drift, low motivation, lost the why | Make the becoming self vivid and present, create contrast |
| `skills/if-then-deploy.md` | Known trigger detected | Pull the pre-loaded plan from if-then-plans.md, activate it |

### Hooks (4 files)

| File | When | Duration |
|------|------|----------|
| `hooks/morning-checkin.md` | Morning, before work starts | 5-10 min |
| `hooks/evening-checkin.md` | End of day, after dinner | 10-15 min |
| `hooks/weekly-review.md` | Sunday evening | 20-30 min |
| `hooks/slip-detected.md` | When mentor detects a slip mid-session | Inline |

## Consequences

- **Easier:** The mentor has a complete operating rhythm — two daily touches, weekly review, and 7 discrete moves it can deploy. Skills are routable from methodology.md's trigger table.
- **Harder:** Wayne has to show up twice a day. Morning + evening is more friction than evening only.
- **Revisit:** After 2 weeks, check if morning check-in is adding value or just creating guilt when skipped.
