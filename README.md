# Mentor Coach

A local-first, folder-based AI mentor focused on **identity transformation** — clarifying who I'm becoming and closing the gap by acting like him today.

> Status: **v1 in design** (started 2026-06-05). Architecture locked, methodology layer in progress.

## What this is

Not a knowledge base. A mentor. He challenges, pushes back, and holds the line on the gap between who I say I'm becoming and what I actually did today.

Methodology is an integrated synthesis of:
- **Identity-based habits** (Atomic Habits) — every action is a vote for who I'm becoming
- **Future-self continuity** (Hershfield) — vivid future-self as the north star
- **Cognitive restructuring** (CBT) — challenging distortions when resistance shows up
- **ACT defusion + values** — separating "I am someone who can't" from underlying values
- **Implementation intentions** (Gollwitzer) — pre-loaded if-then plans for known triggers

## How it's organized

| Folder | Job |
|---|---|
| `mentor/` | Who the mentor is — identity, constitution, methodology, tone, frameworks |
| `me/` | What the mentor knows about me — current identity, becoming, values, weaknesses, triggers, history |
| `goals/` | The active identity arc, 90-day picture, weekly commitments, if-then plans |
| `skills/` | Coaching moves the mentor deploys (score-the-day, challenge-distortion, slip-recovery, etc.) |
| `hooks/` | Triggered routines (daily check-in, weekly review, slip detected) |
| `logs/` | Append-only session record |
| `content/` | Build journal, clips, content ideas — this build is also content |
| `scripts/` | Thin routers over markdown (prompt assembly, hook runners) |
| `.claude/` | Settings + coaching rules |

## Architecture principles

1. **Markdown is source truth.** Scripts route, never override.
2. **YAML frontmatter on every file.** Humans read the body, scripts read the head.
3. **Each folder has one job. Each file has one job.**
4. **Append-only logs separate from editable source.**
5. **v1 is a vertical slice of a larger mentor OS** — sibling arcs and the full 7-mode system are v2+.

## Commit discipline

Every commit doubles as a timestamped journal entry. Format:

```
<scope>: <what changed>

Why: <one line>
Seed: <optional content seed worth a video/post>
```

Scopes: `arch:` `mentor:` `me:` `goals:` `skills:` `hooks:` `journal:` `clip:` `docs:`

## How to use

> Coming in v1.5 — the runtime entry (`CLAUDE.md`) and CLI scripts (`scripts/checkin.py`, `scripts/review.py`) are designed but not yet built. See `content/build-journal.md` for the live build log.

---

License: CC BY 4.0 (see `License CC BY 4.0.txt`).
