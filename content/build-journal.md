# Build Journal

Chronological, raw notes on building this mentor. One entry per working session. Honest about tensions, decisions, and pivots. Content seeds get tagged and harvested into `clips.md` and `ideas.md`.

---

---
date: 2026-06-05
session: 01
arc: identity
phase: brainstorm
tags: [architecture, methodology, version-control, content-strategy]
content-seeds: 5
---

## Session 01 — The first cut

Started with three source docs at the root: a generic EA initialization prompt, a sophisticated "house archetype" mentor spec with 7 advisory modes and a 10-prompt build chain, and a class-assignment brief about building a domain-specific *coach* (not knowledge base) using folder-based interpretable context methodology.

These pull in different directions. The EA prompt wants a second brain. The house-arc doc wants the full mentor OS. The class brief says pick ONE specific domain and judge it by whether it coaches or lectures.

### What I decided

- **The class assignment is the rubric, not the project.** I'm not building a class submission. I'm building v1 of the bigger mentor OS, designed so the class rubric still grades it well (does it coach? is the domain specific? is each file one job? can a stranger use this?). The "coach vs. knowledge base" distinction is the most important guardrail in the entire build — that's what `.claude/rules/coach-not-lecture.md` will enforce.

- **v1 scope: a single identity-transformation arc.** Not whole-life. Not multi-mode. One identity, one mentor voice, one arc — "identify who I'm becoming and start acting in that way." The architecture has slots for sibling arcs and the full 7-mode system, but v1 ships only the spine.

- **Methodology is integrated, not single-school.** The mentor uses identity-based habits as the daily mechanism, future-self vision as the north star, and CBT/ACT cognitive restructuring as the combat moves when I bring resistance. One voice, three tools. This is original synthesis — not a copy of Hormozi, Goggins, or Rohn. Public figures stay invisible inspiration.

- **Markdown is source truth. Scripts are thin routers.** Every `.md` gets YAML frontmatter so scripts can read metadata while humans read the body. A `scripts/assemble_prompt.py` reads frontmatter (`loads:`, `triggers:`) and concatenates the right files into the prompt. The mentor folder is also a valid Obsidian vault.

- **Version control from day 1.** Git was initialized before any mentor files were written. Every meaningful change is a commit. Commit messages double as a searchable timestamped journal — `git log --grep=clip` becomes a content harvester.

- **Content is a first-class folder.** `content/build-journal.md` (this file), `content/clips.md` (extracted soundbites), `content/ideas.md` (video kanban). Building the thing IS the content. The commits are the script.

### Tensions I noticed

- The EA prompt wanted a "Session Start Protocol" telling Claude to read a bunch of files. House-arc said don't do that — let the `@import` system and rules handle file loading. Resolved: no protocol prose, just `@imports` in `CLAUDE.md` plus YAML frontmatter that scripts read.
- The class brief pushed for *one* domain. House-arc pushed for *seven*. Real answer: ship one, architect for seven.
- Big risk on D (integrated methodology) — the rules file gets harder to write cleanly because it has to teach the AI when to deploy each move. Plan: a layered rules file where each method has explicit triggers ("if user reports a slip → slip-recovery skill; if user shows a distortion → challenge-distortion skill"). Coaching moves live in `skills/` so the rules file stays a router, not a textbook.

### Content seeds from this session

1. **"Your build folder IS your content vault. The commits are the script."** — could open a video about building publicly.
2. **"A coach isn't a knowledge base. A knowledge base answers questions. A coach asks better ones."** — the rubric line. Strong YouTube hook.
3. **"Every action is a vote for who you're becoming. Show me today's ballot."** — daily check-in tagline. Bumper-sticker material.
4. **Identity work as two jaws of a vice — vision pull on one side, behavior accountability on the other. A weak mentor only has one jaw.** — could be a whole video on what makes mentorship actually work.
5. **The layered prompt chain (10 prompts → folder → file contracts → real files) is the antidote to "redesigns the architecture every time."** — a video about building complex AI systems without losing the plot.

### What's next

Section 2: design the methodology layer in detail — `mentor/methodology.md`, `mentor/tone.md`, and the `mentor/reference/` framework files. This is where the integrated D method gets cashed out into specifics the mentor can actually coach from.

### Open decisions

- Should the daily check-in be morning + evening (two touches) or evening only (one touch)?
- Where do values get authored — `me/values.md` as a single doc, or split into "stated values" vs. "lived values" so the mentor can audit the gap?
- Does the mentor get to refuse to engage if I show up dishonest? (My instinct: yes. That's part of what makes it a mentor and not a chatbot. Needs to be in `mentor/constitution.md`.)
