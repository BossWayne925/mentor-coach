# Goal-Setting and Deep Work Sessions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add goal-setting and deep work planning as two new structured session types in the mentor coach system.

**Architecture:** Two new hook files following the existing hook pattern (YAML frontmatter + markdown flow sections), one new `projects/` directory for standalone project breakdowns, and two additions to `CLAUDE.md` (routing table rows + file permission rows). No changes to mentor/, skills/, rules/, or update-tracker.ps1.

**Tech Stack:** Markdown, YAML frontmatter. Existing hook files (`hooks/morning-checkin.md`) are the pattern to follow exactly.

---

## File Map

| File | Action |
|---|---|
| `projects/.gitkeep` | Create — establishes the directory |
| `hooks/goal-setting.md` | Create — full goal-setting session hook |
| `hooks/deep-work.md` | Create — full deep work session hook (two sub-modes) |
| `CLAUDE.md` | Modify — add 2 rows to routing table, add 4 rows to file permissions table |

---

## Task 1: Create projects/ directory

**Files:**
- Create: `projects/.gitkeep`

- [ ] **Step 1: Create the directory placeholder**

Create the file `projects/.gitkeep` with empty content. This establishes the directory in git.

- [ ] **Step 2: Verify**

Confirm `projects/` appears when listing the project root. The file should be empty.

- [ ] **Step 3: Commit**

```
git add projects/.gitkeep
git commit -m "chore: add projects/ directory for standalone project breakdowns"
```

---

## Task 2: Create hooks/goal-setting.md

**Files:**
- Create: `hooks/goal-setting.md`
- Reference: `hooks/morning-checkin.md` (follow its format exactly)

- [ ] **Step 1: Verify the existing hook format**

Read `hooks/morning-checkin.md`. Confirm it uses:
- YAML frontmatter with `type`, `name`, `trigger`, `duration`, `loads` fields
- `# Title` heading
- `## Purpose` section
- `## Flow (X minutes)` section with numbered `### N. Step (X min)` subsections

- [ ] **Step 2: Create hooks/goal-setting.md**

Write the following content exactly:

```markdown
---
type: hook
name: goal-setting
trigger: "goal setting", "new goal", "set a goal", "revise my goals", "kill a goal"
duration: 15-20 min
loads: [goals/90-day-picture.md, goals/active-arc.md, goals/weekly-commitments.md, goals/if-then-plans.md, me/becoming.md]
---

# Goal-Setting Session

## Purpose

Define what you're actually going after — or kill what isn't working. Goals that aren't in the system don't exist. Goals that don't have a definition of done aren't goals. This session makes them real.

## Mentor mode

Collaborative but identity-anchored. No refusal escalation — this is a working session. The mentor still holds the becoming portrait and challenges anything that doesn't connect to it.

## Flow (15-20 minutes)

### 1. Orient (1 min)

First question only: "What are we doing — setting a new goal, revising an existing one, or killing something that isn't working?"

- **New goal** → step 2
- **Revision** → "Which goal? Read it back to me." Then step 2 with that goal in focus
- **Kill a goal** → "Name it. Why is it dead — wrong direction, wrong timing, or you're avoiding it?"
  - Wrong direction or timing: remove from `goals/90-day-picture.md` with Wayne's approval, close the session
  - Avoidance: that's not killing — that's quitting. Deploy `skills/challenge-distortion.md` before accepting the kill

### 2. Reality check (3 min)

Before defining anything, check the goal against what already exists:

- "Where does this fit in your 90-day picture?"
- "Is this replacing something, or adding to the pile?" — if adding: "You already have commitments running. What does this displace? Something has to give."
- "Is this coming from the becoming portrait, or did something shiny show up this week?" — if new and shiny: "What does the man you're becoming need more — this new thing, or finishing what you already committed to?"

### 3. Define done (3 min)

No vague goals get written into the system.

- "What ships? What number? What date?"
- If Wayne says "get better at X" or "work on Y" → "That's not done. What does done look like in 30 days? What exists that didn't exist before?"
- Hold this until the output is one sentence: "By [date], I have [specific, observable thing]."

### 4. Obstacle pre-load (3 min)

Every goal gets a defense built before it goes into the system.

- "What's the most likely way this fails? Not 'life happens' — what's your specific failure mode for this specific goal?"
- "Now build the if-then: IF [that specific thing happens], THEN [specific response]."
- Draft the if-then in conversation — do not write to file yet.

### 5. Wire it in (2 min)

With Wayne's approval, write to files:

- Add the goal to `goals/90-day-picture.md` under the right category
- Add the drafted if-then to `goals/if-then-plans.md`
- "Does this need to be on this week's commitments, or does it start next week?" — if this week: suggest the specific addition to `goals/weekly-commitments.md`, Wayne decides

### 6. Close

"It's in the system. You know what done looks like, you know what tries to stop you, and you have a plan for that. What's the first action — the one thing you could do in the next 24 hours that moves this forward?"
```

- [ ] **Step 3: Verify against spec**

Confirm the file covers every spec requirement:
- Orient step handles new / revision / kill-a-goal (kill → challenge-distortion if avoidance) ✓
- Reality check challenges pile-up and shiny-object pattern ✓
- Define done enforces specific + dated output ✓
- Obstacle pre-load drafts if-then in conversation before writing ✓
- Wire it in writes to 90-day-picture.md and if-then-plans.md with approval, suggests weekly-commitments.md ✓
- Close asks for first action ✓

- [ ] **Step 4: Commit**

```
git add hooks/goal-setting.md
git commit -m "feat: add goal-setting session hook"
```

---

## Task 3: Create hooks/deep-work.md

**Files:**
- Create: `hooks/deep-work.md`
- Reference: `hooks/morning-checkin.md` (follow its format)

- [ ] **Step 1: Create hooks/deep-work.md**

Write the following content exactly:

```markdown
---
type: hook
name: deep-work
trigger: "deep work", "break down [project]", "plan my work blocks", "planning session"
duration: 10-20 min
loads: [goals/weekly-commitments.md, goals/if-then-plans.md, TASKS.md]
skills-available: [challenge-distortion]
---

# Deep Work Planning Session

## Purpose

Two modes, one session type. Project breakdown maps a specific project into phases, tasks, and a TASKS.md entry so it's immediately actionable. Day block planning structures a focused workday when you know what you're working on but need to protect the time.

## Sub-mode detection

At session start, one question only: "What are we planning — a specific project breakdown, or today's work blocks?"

Route to the correct flow below. Do not blend the two modes.

---

## Sub-mode A: Project Breakdown (15-20 min)

### 1. Define the project (2 min)

Three questions, in order:
- "Name it. What is it?"
- "What does done look like? One sentence — what ships, what works, what's live?"
- "What's the deadline?" — if none: "Pick one. A project without a deadline is a hobby."

### 2. Break into phases (3-4 min)

- "Walk me through it top-down. 3-5 phases max — what are the major stages?"
- Push back on anything that is a task pretending to be a phase ("write the copy" is a task; "content creation" is a phase)
- Push back on anything that is a project inside a project
- "Which phase has the most unknown in it? That's the one we plan most carefully."

### 3. Phase 1 into tasks (3-4 min)

Break phase 1 only into concrete tasks:
- Each task: one action, completable in a single focused work block (90 min or less)
- "Is that a task or a project inside a project?"
- "What does done look like for that specific task?"
- These go into `TASKS.md` under a new section named after the project

### 4. Standalone project file (2 min)

The full breakdown (all phases, key decisions, definition of done) goes into `projects/[project-name].md`. `TASKS.md` gets phase 1 tasks only — keeps the board clean and immediately actionable.

Both files written with Wayne's approval.

### 5. Blocker pre-load (2 min)

- "What's the most likely thing that stalls this project at the halfway point? Not the first week — the halfway point, when the novelty is gone."
- "Build the if-then: IF [that stall trigger], THEN [specific move]."
- Add to `goals/if-then-plans.md` with Wayne's approval.

### 6. Close

"Phase 1 is in TASKS.md. You know what done looks like and what tries to stop you halfway. What's the first task you're doing today — not tomorrow, today?"

---

## Sub-mode B: Day Block Planning (10 min)

### 1. Anchor to commitments (1 min)

- "What's the most important thing you need to move today?"
- Must connect to this week's commitments in `goals/weekly-commitments.md`
- If it doesn't: "That's not on your commitments list. What's more important — that, or what you said this week was the priority?"

### 2. Inventory the day (2 min)

- "How many hours of real focused time do you have today — not total waking hours, actual focused work hours?"
- "Any hard constraints? Appointments, pickups, fixed obligations that break the day up?"

### 3. Block the time (3 min)

Structure the day into three slots:
- **Deep work block** — when, what, how long (single task, protected time, no interruptions)
- **Shallow work window** — email, admin, small tasks
- **Protected stop time** — when work ends

"When is your best focus window today — morning, afternoon, or evening?"
"What goes in that window and nothing else?"

### 4. Resistance pre-load (2 min)

- "What's most likely to pull you off this plan today? Name it specifically."
- Build the if-then for today's biggest threat: IF [specific pull], THEN [specific response]
- This if-then stays in conversation — it does not write to `goals/if-then-plans.md`. It's a one-day plan, not a standing rule.

### 5. Commit (1 min)

Summarize back: "You have [X focused hours], [Y] is the priority in your [morning/afternoon/evening] block, and if [Z] tries to pull you off it you [response]. Are you in?"

No hedging. Yes or no.

## What this is NOT

- Not a morning check-in. Don't score yesterday or set an identity anchor. Go straight to the planning flow.
- Not a freeform session. Stay in the chosen sub-mode. If a coaching trigger fires mid-session (excuse, avoidance, distortion), deploy the matching skill, then return to the plan.
```

- [ ] **Step 2: Verify against spec**

Confirm the file covers every spec requirement:
- Sub-mode detection question at start ✓
- Sub-mode A: define → phases → phase 1 tasks → project file → blocker if-then → close ✓
- Sub-mode A: TASKS.md gets phase 1 only, projects/[name].md gets full breakdown ✓
- Sub-mode A: if-then writes to goals/if-then-plans.md with approval ✓
- Sub-mode B: anchor to commitments → inventory → block the time → resistance pre-load → commit ✓
- Sub-mode B: day if-then stays in conversation, does NOT write to if-then-plans.md ✓

- [ ] **Step 3: Commit**

```
git add hooks/deep-work.md
git commit -m "feat: add deep work planning session hook"
```

---

## Task 4: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

Two changes: routing table (add 2 rows), file permissions table (add 4 rows).

- [ ] **Step 1: Add goal-setting and deep-work rows to the session routing table**

Find this block in `CLAUDE.md`:

```markdown
| Wayne says | Hook | Also load |
|-----------|------|-----------|
| "morning check-in" or it's the start of his day | `hooks/morning-checkin.md` | `goals/weekly-commitments.md`, `goals/if-then-plans.md` |
| "evening check-in" or "end of day" or "score my day" | `hooks/evening-checkin.md` | `goals/weekly-commitments.md`, `me/values-stated.md`, `me/values-lived.md` |
| "weekly review" or it's Sunday evening | `hooks/weekly-review.md` | `goals/90-day-picture.md`, `goals/active-arc.md`, `me/weaknesses.md` |
| Anything else | No hook — freeform session | Route to skills as triggers arise |
```

Replace with:

```markdown
| Wayne says | Hook | Also load |
|-----------|------|-----------|
| "morning check-in" or it's the start of his day | `hooks/morning-checkin.md` | `goals/weekly-commitments.md`, `goals/if-then-plans.md` |
| "evening check-in" or "end of day" or "score my day" | `hooks/evening-checkin.md` | `goals/weekly-commitments.md`, `me/values-stated.md`, `me/values-lived.md` |
| "weekly review" or it's Sunday evening | `hooks/weekly-review.md` | `goals/90-day-picture.md`, `goals/active-arc.md`, `me/weaknesses.md` |
| "goal setting", "new goal", "set a goal", "revise my goals", "kill a goal" | `hooks/goal-setting.md` | `goals/90-day-picture.md`, `goals/active-arc.md`, `goals/weekly-commitments.md`, `goals/if-then-plans.md`, `me/becoming.md` |
| "deep work", "break down [project]", "plan my work blocks", "planning session" | `hooks/deep-work.md` | `goals/weekly-commitments.md`, `goals/if-then-plans.md`, `TASKS.md` |
| Anything else | No hook — freeform session | Route to skills as triggers arise |
```

- [ ] **Step 2: Add write permissions to the file permissions table**

Find this block in `CLAUDE.md`:

```markdown
| Mark weekly commitment complete (`[x]`) in `goals/weekly-commitments.md` | Yes — when Wayne confirms completing a commitment during a session, offer to mark it `[x]` immediately. Don't wait for the weekly review. |
| Modify `mentor/`, `skills/`, `hooks/`, `rules/` | No — these are system files. Wayne changes them outside sessions. |
```

Replace with:

```markdown
| Mark weekly commitment complete (`[x]`) in `goals/weekly-commitments.md` | Yes — when Wayne confirms completing a commitment during a session, offer to mark it `[x]` immediately. Don't wait for the weekly review. |
| Add or remove targets in `goals/90-day-picture.md` | Yes — during goal-setting session only, with Wayne's approval before any write |
| Add to `goals/if-then-plans.md` | Yes — during goal-setting or deep work project breakdown, with Wayne's approval before any write |
| Add project section to `TASKS.md` | Yes — during deep work project breakdown only, with Wayne's approval before any write |
| Write to `projects/` | Yes — standalone project breakdown files during deep work, with Wayne's approval before any write |
| Modify `mentor/`, `skills/`, `hooks/`, `rules/` | No — these are system files. Wayne changes them outside sessions. |
```

- [ ] **Step 3: Verify CLAUDE.md**

Confirm:
- Routing table has 6 rows now (morning, evening, weekly review, goal-setting, deep work, anything else)
- "Anything else → freeform" is still the last row
- File permissions table has the 4 new rows between the commitment checkbox row and the "Modify system files" row
- No existing rows were accidentally removed or modified

- [ ] **Step 4: Commit**

```
git add CLAUDE.md
git commit -m "feat: wire goal-setting and deep work sessions into CLAUDE.md routing"
```

---

## Task 5: Final verification and push

- [ ] **Step 1: Confirm all files exist**

```powershell
Get-ChildItem E:\mentor_coach\hooks\
Get-ChildItem E:\mentor_coach\projects\
```

Expected output includes: `goal-setting.md`, `deep-work.md`, `morning-checkin.md`, `evening-checkin.md`, `weekly-review.md`, `slip-detected.md` in hooks/. `.gitkeep` in projects/.

- [ ] **Step 2: Spot-check routing table has 6 trigger rows**

```powershell
Select-String -Path E:\mentor_coach\CLAUDE.md -Pattern "hooks/"
```

Expected: 6 lines matching `hooks/` in the routing table section (morning-checkin, evening-checkin, weekly-review, goal-setting, deep-work, and the "No hook" row doesn't count).

- [ ] **Step 3: Confirm session log types note is still accurate**

Find the line in `CLAUDE.md`:
```
Session log types: `morning`, `evening`, `weekly-review`, `freeform`
```

This is correct — goal-setting and deep work both write `freeform` type logs. No change needed.

- [ ] **Step 4: Push to GitHub**

```
git push origin main
```

- [ ] **Step 5: Done**

The mentor now responds to:
- "goal setting" / "new goal" / "set a goal" / "revise my goals" / "kill a goal" → structured goal-setting flow
- "deep work" / "break down [project]" / "plan my work blocks" / "planning session" → project breakdown or day block planning
