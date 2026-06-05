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
- ~~Where do values get authored~~ — **Resolved session 02: split into stated vs. lived.**
- Does the mentor get to refuse to engage if I show up dishonest? (My instinct: yes. That's part of what makes it a mentor and not a chatbot. Needs to be in `mentor/constitution.md`.)

---

---
date: 2026-06-05
session: 02
arc: identity
phase: brainstorm → design
tags: [me-layer, self-knowledge, values-gap, architecture, content-strategy]
content-seeds: 6
---

## Session 02 — The mirror

Designed and filled the entire `me/` layer — the 6 files that give the mentor its memory of who Wayne is. This is the most personal folder in the project and the one that makes the difference between a generic AI coach and one that actually knows you.

### Decisions made and why

**Decision #09 (locked): `me/` layer is 6 files with values split into stated vs. lived.**

- **Values split (stated vs. lived)** — This was the big one. A single `values.md` would have worked semantically, but the whole point of this mentor is closing the gap between who you say you're becoming and what you actually do. Making the gap structural — two separate files with a diff table — means the mentor *can't* ignore it. It's not a prose observation, it's architecture. The mentor reads both files every session and the gap table is the primary coaching lever.

- **History dropped as standalone** — The original plan had a `me/history.md`. Killed it. History is a vanity doc that invites a biography the mentor doesn't need. What the mentor needs is where Wayne is *right now* (identity-now.md) and where he's going (becoming.md). Session history lives in `logs/`. Origin context lives as a section in identity-now.md. One file, one job.

- **Ownership boundary: Wayne writes, mentor reads** — The mentor can *suggest* updates to `values-lived.md` and append observed patterns to `weaknesses.md` and `triggers.md`, but Wayne approves all changes. The mentor never rewrites who Wayne says he is. This boundary is what separates a coach from a system that gaslights you with its own conclusions.

- **YAML frontmatter includes `confidence` and `last-reviewed`** — `confidence` lets the mentor probe uncertain self-knowledge ("You marked your triggers as low-confidence — let's test that"). `last-reviewed` triggers revisits when files go stale. The mentor should never coach from outdated self-knowledge.

### What the interview revealed

The gap table in `values-lived.md` is the most important artifact from this session. Three values align (independence, family, loyalty). Four have real daylight:

- **Integrity vs. Comfort** — says he'll do things, then drifts
- **Focus vs. Novelty** — claims focus but the pattern is start-stop-start
- **No BS tolerance vs. Avoidance** — calls BS on others but hasn't fully called it on his own patterns
- **Daily growth vs. Learning without output** — grows in knowledge but not in results

This gap table is what the mentor reads before every coaching move. It's the thing that keeps the mentor honest.

### Tensions I noticed

- **Isolation is both a strength and a risk.** Wayne's "becoming" self uses strategic isolation as a discipline tool (phone off, unavailable, disconnect). But isolation also means nobody checks on what he said he'd do. The mentor needs to be the accountability that isolation would otherwise remove.
- **Learning is the most dangerous comfort zone.** It feels productive. It looks like growth. But research without shipping is consumption, not creation. The mentor needs a coaching move that distinguishes studying from stalling.
- **The last 10% problem.** Wayne doesn't quit at the beginning — he quits at the end. The 90%-done project graveyard is real. This means the mentor's hardest job isn't motivation, it's finishing accountability.

### Content seeds from this session

1. **"The gap between your stated values and your lived values is the only thing a mentor needs to see."** — the core thesis of the values split. Strong hook for a video about self-honesty.
2. **"I wrote down my values. Then I wrote down what my actions actually say I value. They didn't match."** — raw, personal, build-in-public moment. This is the video.
3. **"Learning feels like progress. But if you're not shipping, you're just a consumer with a notebook."** — tough line. YouTube short material.
4. **"Most people don't quit at the start. They quit at 90%. The last 10% is where everything dies."** — universal truth. Video about the finishing problem.
5. **"My AI mentor can't rewrite who I say I am. It can only show me who my actions say I am."** — the ownership boundary explained. Hits on AI ethics and self-coaching.
6. **"I built the most honest folder on my computer. It's 6 markdown files that know me better than my friends do."** — build-in-public hook. Vulnerable, specific, memorable.

### What's next

Section 2 (methodology layer) or Section 4 (goals + skills + hooks) — both are unblocked. Section 3 is done. Two open decisions remain: daily check-in cadence and whether the mentor can refuse dishonest engagement.
