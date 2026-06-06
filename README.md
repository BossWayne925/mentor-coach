# Mentor Coach

A local-first, folder-based AI mentor focused on **identity transformation** — clarifying who I'm becoming and closing the gap by acting like him today.

> **Building in public.** Every commit is a timestamped journal entry. The build journal, content seeds, and decision log are all in this repo. Follow along or fork it and build your own.

> Status: **v1 in design** (started 2026-06-05). Sections 1-4 complete. Runtime layer (Section 5) in progress.

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
| `content/` | Build journal, clips, video ideas, lessons — the build IS the content | 4 |
| `docs/` | Architecture decisions (ADRs) and locked decisions register | 4 |
| `logs/` | Append-only session records *(coming in v1.5)* | — |
| `scripts/` | Prompt assembly and hook runners *(coming in v1.5)* | — |

**Architecture principles:** Markdown is source truth. YAML frontmatter on every file. Each folder has one job. Each file has one job. Append-only logs separate from editable source.

## The build-in-public layer

This project doubles as content fuel. Every working session produces:

- **Build journal entries** (`content/build-journal.md`) — raw notes on decisions, tensions, and reasoning
- **Clips** (`content/clips.md`) — extracted one-liners worth a video or post
- **Video ideas** (`content/ideas.md`) — backlog of content seeded from the build
- **Commit messages** — each one has a `Seed:` line for searchable content seeds (`git log --grep=Seed`)

## Follow the build

- **Build journal:** [`content/build-journal.md`](content/build-journal.md) — 3 sessions documented so far
- **Decision log:** [`docs/decisions/DECISIONS.md`](docs/decisions/DECISIONS.md) — 11 locked architectural decisions
- **Content seeds:** [`content/clips.md`](content/clips.md) — 18 clips extracted
- **Video ideas:** [`content/ideas.md`](content/ideas.md) — 11 ideas in backlog

## Commit discipline

Every commit doubles as a timestamped journal entry:

```
<scope>: <what changed>

Why: <one line>
Seed: <optional content seed worth a video/post>
```

Scopes: `arch:` `mentor:` `me:` `goals:` `skills:` `hooks:` `journal:` `clip:` `docs:`

## Fork it

This is licensed CC BY 4.0. Fork it, swap out the `me/` folder with your own answers, adjust the methodology, and build your own mentor. The architecture is the value — the personal content is just mine.

---

Built by [Wayne @ EastBay Creative Solutions](https://github.com/BossWayne925) with Claude Code.

License: CC BY 4.0 (see `License CC BY 4.0.txt`).
