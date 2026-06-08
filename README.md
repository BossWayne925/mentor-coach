# Mentor Coach

A local-first, folder-based AI mentor focused on **identity transformation** — clarifying who I'm becoming and closing the gap by acting like him today.

> Status: **Active** (started 2026-06-05). Built in Claude Code. Morning/evening check-ins running live. Tracker auto-updating via hook.

## Why this exists

I'm not where I want to be. I know who I want to become, but my actions don't always match. I built this to hold myself accountable — not with a chatbot that tells me what I want to hear, but with a mentor that challenges me, calls my bullshit, and walks away when I'm not being real.

This is not a knowledge base. A knowledge base answers questions. A coach asks better ones.

## What makes it different

- **The mentor can refuse to engage.** If I show up dishonest — deflecting, performing growth, going through the motions — the mentor disengages. "We're done for today. Come back when you're ready to be real."
- **Stated vs. lived values gap.** Two separate files track what I *say* I value and what my *actions* reveal. The gap between them is the primary coaching lever.
- **7 coaching moves mapped to 7 failure modes.** Not generic advice — specific responses for my specific triggers (plateau boredom, avoidance of rejection, the last-10% problem, etc.)
- **If-then plans for known triggers.** Pre-loaded responses decided before the moment hits, so willpower isn't the only defense.
- **Every action is framed as an identity vote.** Not "did you do the task" but "what did your actions vote for today?"

## Methodology

An integrated synthesis — one voice, three tools:

| Tool | Job | When |
|------|-----|------|
| **Identity lens** | Frame every action as a vote for who I'm becoming | Every check-in |
| **Future-self pull** | Make the becoming self vivid and present | When drifting or lost |
| **Restructuring** | Challenge distortions, separate me from limiting stories | When resistance shows up |

Built on principles from identity-based habits, future-self psychology, and cognitive restructuring — but the mentor never names the frameworks. He just uses them.

## How it's organized

| Folder | Job | Files |
|--------|-----|-------|
| `mentor/` | Who the mentor is — identity, methodology, tone | 3 |
| `me/` | What the mentor knows about me — identity, becoming, values (stated + lived), weaknesses, triggers | 6 |
| `goals/` | Active arc, 90-day targets, weekly commitments, if-then plans | 4 |
| `skills/` | Coaching moves — score-the-day, challenge-distortion, slip-recovery, finish-push, study-or-stall, future-self-pull, if-then-deploy | 7 |
| `hooks/` | Triggered routines — morning check-in, evening check-in, weekly review, slip detected | 4 |
| `rules/` | Non-negotiable behavioral constraints — coach-not-lecture, pushback-style, markdown-discipline | 3 |
| `logs/` | Append-only session records + auto-generated tracker + weekly summaries | live |
| `scripts/` | PowerShell tracker generator, Pester tests | live |
| `docs/` | Architecture decisions (ADRs) and locked decisions register | 4 |

**Architecture principles:** Markdown is source truth. YAML frontmatter on every file. Each folder has one job. Each file has one job. Append-only logs separate from editable source.

## The automation layer

Sessions don't just get written — they drive the tracker automatically.

```
Write session log → PostToolUse hook fires → scripts/update-tracker.ps1 runs → logs/tracker.md regenerates
```

`logs/tracker.md` always shows:
- Current becoming streak (consecutive evening scores of "becoming")
- This week's session grid (morning / evening / score per day)
- Weekly commitment progress (reads checkboxes from `goals/weekly-commitments.md`)
- Plan vs. done hit rate across all sessions
- Patterns flagged (comfort zone streak, low hit rate, worst day-of-week)

## Tools

**`coach.html`** — Zen Coach dashboard. Open the workspace folder to surface:
- Identity snapshot (sessions, streak, plan hit rate, 90-day progress)
- Who you're becoming (portrait from `me/becoming.md`)
- Identity gap table (stated vs. lived values)
- Weekly commitments with pass/fail status
- 90-day picture with per-target progress
- Recent sessions + voice reflection
- Remembers your last workspace folder via IndexedDB

**`dashboard.html`** — Kanban/list task board. Reads and writes `TASKS.md`. Drag-and-drop columns, subtasks, inline editing, auto-save.

## The session loop

Five session types, each with its own hook:

**Morning check-in** (5-10 min) — Identity anchor, top 3 tasks, pre-loaded if-then plans, hard commit.

**Evening check-in** (10-15 min) — Score the day (becoming / mixed / comfort zone won), hard question, values check, set tomorrow.

**Weekly review** (20-30 min) — Score each commitment pass/fail, pattern check against known failure modes, values audit with `me/` file update, 90-day progress check, set next week's 5 commitments.

**Goal-setting** (15-20 min) — Set a new goal, revise an existing one, or officially kill something that isn't working. Enforces a definition of done, loads an obstacle if-then, and wires the goal into `goals/90-day-picture.md` and `goals/if-then-plans.md`.

**Deep work planning** (10-20 min) — Two sub-modes: project breakdown (map a project into phases, drop phase 1 tasks into `TASKS.md`, write a standalone project file to `projects/`) or day block planning (anchor to commitments, block focused time, pre-load resistance response).

## Fork it

This is licensed CC BY 4.0. The architecture is the value — the personal content is mine. Here's what it actually takes to make it yours.

**Estimated time: 2-4 hours.** Most of that is the self-knowledge work, not the setup.

### Setup steps

**1. Fork and clone the repo**

**2. Set your name**

Open `me/identity-now.md` and update the `name:` field in the frontmatter:
```yaml
name: Your Name
```
The mentor reads this at session start and uses it throughout. That's the only place your name needs to live.

**3. Replace the `me/` folder — all 6 files**

This is the real work. Don't rush it. Shallow answers produce shallow coaching.

| File | What goes in it |
|------|-----------------|
| `me/identity-now.md` | Where you are today — background, current defaults, how you see yourself honestly |
| `me/becoming.md` | Who you're becoming — the portrait of the person you're building toward |
| `me/values-stated.md` | What you say you value — list them |
| `me/values-lived.md` | What your actions reveal you actually value — the gap between this and stated is the primary coaching lever |
| `me/weaknesses.md` | Your specific failure modes — the 3-5 patterns that consistently take you off course |
| `me/triggers.md` | Known situations that activate your worst defaults — with pre-built if-then responses |

**4. Replace the `goals/` folder**

| File | What goes in it |
|------|-----------------|
| `goals/active-arc.md` | The current chapter — what you're building, what this season is about |
| `goals/90-day-picture.md` | Specific targets 90 days out, by category, with checkboxes |
| `goals/weekly-commitments.md` | This week's 5 commitments — concrete, completable, deadline attached |
| `goals/if-then-plans.md` | Pre-built responses to your known failure triggers (built from `me/triggers.md`) |

**5. Clear the logs**

Delete everything in `logs/sessions/` and reset `logs/tracker.md` to a blank state. Those are mine.

**6. Optionally adjust the mentor's voice**

The default persona in `mentor/identity.md` and `mentor/tone.md` is the tough older brother — direct, no performance tolerated, short sentences. If that doesn't fit you, change it. The architecture doesn't depend on the persona.

**7. Start a morning check-in**

That's it. The system is live. The mentor reads your `me/` files at session start.

---

Built by [Wayne @ EastBay Creative Solutions](https://github.com/BossWayne925) with Claude Code.

License: CC BY 4.0 (see `License CC BY 4.0.txt`).
