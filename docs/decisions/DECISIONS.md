# Locked Decisions

Append-only register of architectural and design decisions that are **locked** — later prompts and sessions must not re-litigate them unless I explicitly reopen one. Pattern borrowed from the house-arc doc's "approved-decisions.md" idea.

Format:
```
[YYYY-MM-DD #NN] DECISION: <what> | WHY: <one line> | STATUS: locked | REOPENED: <date if applicable>
```

---

[2026-06-05 #01] DECISION: v1 is a single-arc, single-voice mentor focused on identity transformation. | WHY: Shippable this week; satisfies class rubric; clean spine for v2 expansion. | STATUS: locked

[2026-06-05 #02] DECISION: Methodology is integrated D — identity-based habits + future-self vision + CBT/ACT cognitive restructuring, fused into one mentor voice. | WHY: Single-school methods only hit one of "challenge / build habit / clarify becoming." Integrated covers all three. | STATUS: locked

[2026-06-05 #03] DECISION: Markdown is source truth. Scripts are thin routers over markdown. YAML frontmatter is the connective tissue. | WHY: Keeps the system human-editable, Obsidian-friendly, portable across Claude Code / Gemini CLI / local scripts. | STATUS: locked

[2026-06-05 #04] DECISION: Every folder has one job. Every file has one job. | WHY: Class rubric. Also matches Wayne's stated preference for interpretable context. | STATUS: locked

[2026-06-05 #05] DECISION: Public figures (Hormozi, Goggins, Rohn, Clear, etc.) are invisible inspiration. They do not appear by name in mentor identity, tone, or rules. | WHY: Original archetype is more portable and timeless than a collage of borrowed names. | STATUS: locked

[2026-06-05 #06] DECISION: Logs (`logs/`) and content (`content/`) are separate folders with separate jobs. Logs = append-only mentor session records. Content = build journal, clips, ideas for video/post fuel. | WHY: Different decay cycles. Different audiences. Different formats. | STATUS: locked

[2026-06-05 #07] DECISION: Git is initialized from day 1. Every meaningful change is a commit. Commit messages follow `<scope>: <what>` with optional `Seed:` line so content seeds are searchable via `git log --grep`. | WHY: Wayne wants documentation from day 1 and content notes as a byproduct of the build. | STATUS: locked

[2026-06-05 #08] DECISION: Coaching moves live in `skills/` as discrete files. The rules file is a router that points to skills based on triggers, not a textbook. | WHY: Keeps the integrated methodology manageable — each move is one file, the rules file stays a thin index. | STATUS: locked

[2026-06-05 #10] DECISION: Methodology layer is 3 files (identity.md, methodology.md, tone.md), no reference subfolder. Frameworks are invisible — the mentor uses their moves without naming them. Mentor has constitutional right to refuse dishonest engagement. | WHY: Reference files invite multi-school drift and textbook behavior. The integrated voice stays integrated only if the frameworks stay invisible. Refusal right is what separates a mentor from a chatbot. | STATUS: locked

[2026-06-05 #09] DECISION: `me/` layer is 6 files: identity-now, becoming, values-stated, values-lived, weaknesses, triggers. Values split into stated vs. lived so the gap is structural and machine-diffable. History dropped as standalone (lives in identity-now + logs). Wayne writes, mentor reads — mentor suggests updates but Wayne approves. YAML frontmatter includes last-reviewed and confidence fields. | WHY: The stated/lived values gap is the core coaching lever; making it structural forces the mentor to engage with it. One file, one job. | STATUS: locked
