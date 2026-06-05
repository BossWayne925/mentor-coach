# ADR-09: `me/` Layer Architecture

**Status:** Accepted
**Date:** 2026-06-05
**Deciders:** Wayne

## Context

The `me/` folder is the mentor's memory of who Wayne is — current state, aspirational state, values, vulnerabilities, triggers, and history. Every coaching move reads from this folder to personalize its response. Without it, the mentor is generic; with bad structure, the mentor hallucinates context or misses the gap between who Wayne says he is and what he actually does.

Six files were named in the original architecture (NEXT-SESSION.md). One open decision remains: should values be a single doc or split into "stated vs. lived" to let the mentor audit the gap?

The `me/` layer is **Wayne-authored, mentor-referenced.** Wayne writes these files (with mentor help during onboarding). The mentor reads them but never overwrites them — it can *suggest* updates after sessions, but Wayne approves edits. This is a key boundary: the mentor doesn't get to redefine who Wayne is.

## Decision

Six files in `me/`, each with YAML frontmatter and a single job:

| File | Job | Updated by |
|------|-----|------------|
| `me/identity-now.md` | Who Wayne is today — honest snapshot of current habits, defaults, and self-concept | Wayne (mentor may surface contradictions) |
| `me/becoming.md` | Who Wayne is becoming — the vivid future-self portrait the mentor holds as north star | Wayne |
| `me/values-stated.md` | Values Wayne claims — what he says matters most | Wayne |
| `me/values-lived.md` | Values Wayne's actions reveal — what his calendar, habits, and choices actually show | Mentor suggests, Wayne approves |
| `me/weaknesses.md` | Known failure modes, avoidance patterns, comfort-zone defaults | Wayne + mentor (mentor can append observed patterns) |
| `me/triggers.md` | Situations, emotions, or contexts that reliably produce slips or avoidance | Wayne + mentor |

### Why split values into two files?

The gap between stated and lived values is the single most productive tension in identity coaching. A mentor who only knows stated values becomes a cheerleader. A mentor who can compare stated vs. lived can say: *"You say growth matters, but you skipped the hard thing three days in a row — which value is actually winning?"*

Splitting into two files (not two sections of one file) makes the gap machine-readable. The mentor's coaching moves can diff the two files and surface contradictions. A single file with both sections would work semantically but loses the clean "one file, one job" principle from Decision #04.

### Dropped: `me/history.md`

The original plan named 6 files including "history." On reflection, history is better served by `logs/` (append-only session records) and `me/identity-now.md` (which can include a brief origin paragraph). A separate history file invites a biography that the mentor doesn't need to coach effectively. If Wayne wants to add formative-experience context, it belongs as a section in `identity-now.md` under a `## Where I'm coming from` heading.

This keeps the count at 6 files (values split into 2 replaces history as a standalone).

## Options Considered

### Option A: 6 files with values split (Recommended)

| Dimension | Assessment |
|-----------|------------|
| Complexity | Low — 6 small markdown files |
| Coaching quality | High — stated/lived gap is machine-diffable |
| One-file-one-job | Clean — each file has exactly one job |
| Onboarding burden | Medium — Wayne needs to fill 6 files, but `values-lived.md` can start sparse and grow |

**Pros:**
- The stated/lived gap is the core coaching lever — making it structural means the mentor can't ignore it
- `values-lived.md` becomes a living document the mentor updates with evidence from sessions
- Clean separation means Wayne can edit stated values without accidentally changing the mentor's observed-behavior notes

**Cons:**
- Wayne has to be honest enough to let `values-lived.md` diverge from `values-stated.md`
- Two values files is slightly more overhead than one

### Option B: 5 files with values as single doc + history

| Dimension | Assessment |
|-----------|------------|
| Complexity | Low |
| Coaching quality | Medium — values gap is prose, not structural |
| One-file-one-job | Violated — `values.md` does two jobs |
| Onboarding burden | Medium-high — history file invites a long biography |

**Pros:**
- Simpler mental model (one values file)
- History file gives rich context

**Cons:**
- Values gap lives in prose sections, easy for the mentor to gloss over
- History file has no clear scope — how much is enough?
- Violates decision #04 (one file, one job)

### Option C: 4 files (merge weaknesses + triggers, single values)

| Dimension | Assessment |
|-----------|------------|
| Complexity | Lowest |
| Coaching quality | Lower — less granularity for coaching moves to hook into |
| One-file-one-job | Violated in merged files |
| Onboarding burden | Low |

**Pros:**
- Fewest files to maintain

**Cons:**
- Weaknesses and triggers serve different coaching moves (weaknesses → pattern-awareness, triggers → if-then plans). Merging makes the router in `skills/` harder to write.
- Less surface area for the mentor to work with

## Trade-off Analysis

The real trade-off is **structural honesty vs. simplicity.** Option A forces the stated/lived gap into the file system where the mentor *must* engage with it. Option B keeps it as prose the mentor *might* engage with. Given that the whole point of this mentor is identity transformation — closing the gap between who Wayne says he's becoming and what he actually does — the gap should be structural.

The dropped history file is a simplicity win. Session logs capture what happened; `identity-now.md` captures where Wayne is. A standalone history file is a vanity doc that doesn't improve coaching.

## YAML Frontmatter Contract

Every `me/` file uses this frontmatter:

```yaml
---
type: self-knowledge
domain: [identity | becoming | values-stated | values-lived | weaknesses | triggers]
last-reviewed: 2026-06-05
confidence: [high | medium | low]  # how sure Wayne is this is accurate
---
```

`last-reviewed` lets the mentor prompt Wayne to revisit stale self-knowledge. `confidence` lets the mentor know which files to probe ("You marked your triggers as low-confidence — let's test that").

## Consequences

- **Easier:** Coaching moves in `skills/` can target specific files (e.g., `challenge-distortion` reads `values-stated.md` + `values-lived.md` and surfaces gaps). The mentor's prompt assembly becomes precise.
- **Harder:** Wayne has to fill 6 files honestly. `values-lived.md` requires looking at behavior, not aspirations. This is uncomfortable by design.
- **Revisit:** After 2-3 weeks of use, check whether `weaknesses.md` and `triggers.md` should merge or stay separate. Also check whether `values-lived.md` is actually getting updated by mentor suggestions or going stale.

## Action Items

1. [ ] Wayne decides: approve or modify this proposal
2. [ ] Wayne fills `me/identity-now.md` and `me/becoming.md` (interview-style, mentor can help)
3. [ ] Wayne fills `me/values-stated.md`
4. [ ] Wayne + mentor co-create initial `me/values-lived.md` (can start near-empty)
5. [ ] Wayne fills `me/weaknesses.md` and `me/triggers.md`
6. [ ] Lock as Decision #09 in DECISIONS.md once approved
