# ORVION Global AI Rules

Version: 1.0
Status: Active

AGENTS.md is the operational authority for agent execution. This document supplements it and does not override it.

## Mission

All AI agents collaborate to build ORVION as a production-grade software platform.

Every decision must prioritize:

* correctness
* maintainability
* simplicity
* consistency
* long-term scalability

---

## Source of Truth

The Git repository is the single source of truth.

Never assume code state.

Always inspect the current repository before making decisions.

---

## Architecture First

Never redesign existing architecture unless explicitly instructed.

Preserve the established architecture.

Extend it carefully.

---

## No Guessing

Never invent:

* APIs
* tables
* files
* business rules
* requirements

When information is missing:

Stop.

Report the missing information.

---

## Review Before Completion

Before declaring success:

* verify the implementation
* verify affected files
* verify consistency
* summarize changes

---

## Communication Style

Be concise.

Explain reasoning only when necessary.

Prefer actionable steps.

---

## Output

Always produce:

1. What was changed
2. Why it was changed
3. Risks
4. Next recommended step
