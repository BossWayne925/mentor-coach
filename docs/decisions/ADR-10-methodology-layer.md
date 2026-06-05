---
status: Proposed
date: 2026-06-05
deciders: Wayne
---

# ADR-10: Methodology Layer Architecture

**Status:** Accepted
**Date:** 2026-06-05
**Deciders:** Wayne

## Context

The methodology layer defines who the mentor is, how it coaches, and how it sounds. Decision #02 locked the integrated methodology (identity-based habits + future-self vision + CBT/ACT restructuring). This ADR decides how to structure that into files.

The original plan (NEXT-SESSION.md) called for `mentor/methodology.md`, `mentor/tone.md`, and 5 reference files in `mentor/reference/`. The reference folder risks pulling the mentor back toward multi-school mode — picking frameworks like a textbook instead of coaching as one integrated voice.

Also resolves the open question: can the mentor refuse to engage when Wayne shows up dishonest?

## Decision

Three files in `mentor/`, no reference subfolder:

| File | Job |
|------|-----|
| `mentor/identity.md` | Who the mentor is — persona, principles, constitution (including refusal rights) |
| `mentor/methodology.md` | How the mentor coaches — the integrated method as trigger→move mappings, not academic frameworks |
| `mentor/tone.md` | How the mentor sounds — voice, patterns, what he says and never says |

### Why no reference folder?

The 5 source frameworks (Atomic Habits, Future-Self, CBT, ACT, Implementation Intentions) are *inspiration*, not *identity*. Decision #05 already says public figures stay invisible. The same principle applies to the frameworks themselves — the mentor doesn't say "let's use CBT defusion here." It says "you're fusing with that story again — let's separate you from it."

The framework roots live as a single section inside `methodology.md` that maps triggers to moves. The mentor knows what to *do*, not what school it comes from.

### Mentor can refuse dishonest engagement

Written into `mentor/identity.md` as a constitutional right. If Wayne shows up clearly bullshitting — deflecting, minimizing, performing growth instead of doing it — the mentor names the pattern and disengages until Wayne is ready to be honest. This is the line between a mentor and a chatbot. A chatbot always responds. A mentor respects itself enough to walk away.

## Options Considered

### Option A: 3 files, no reference folder (Chosen)

| Dimension | Assessment |
|-----------|------------|
| Complexity | Low — 3 files, clear jobs |
| One-voice risk | Low — no framework files to pull toward multi-school |
| Coaching quality | High — moves are trigger-mapped, not theory-mapped |
| Extensibility | Medium — v2 can add reference files if needed |

**Pros:** Stays integrated, mentor never breaks voice to cite a framework, clean routing
**Cons:** Less explicit documentation of framework roots (acceptable — frameworks are inspiration, not identity)

### Option B: 3 files + 5 reference files

| Dimension | Assessment |
|-----------|------------|
| Complexity | Medium — 8 files |
| One-voice risk | Higher — reference files invite the mentor to "switch frameworks" |
| Coaching quality | Medium — more knowledge, but knowledge isn't coaching |

**Pros:** Thorough documentation of each framework
**Cons:** Violates the integrated-voice principle, invites textbook behavior

## Consequences

- **Easier:** The mentor stays in one voice. No framework-switching. Skills in `skills/` can reference methodology.md for their trigger→move mapping.
- **Harder:** If someone wants to understand *why* the mentor does what it does at a framework level, they'd need to read the build journal or the README, not a reference folder.
- **Revisit:** If methodology.md grows past ~200 lines, consider splitting by coaching domain (not by framework).

## Action Items

1. [ ] Wayne approves this proposal
2. [ ] Write `mentor/identity.md`
3. [ ] Write `mentor/methodology.md`
4. [ ] Write `mentor/tone.md`
5. [ ] Lock as Decision #10 in DECISIONS.md
