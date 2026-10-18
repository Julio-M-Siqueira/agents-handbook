---
name: code-quality-auditor
description: Standards and architecture review for algotrading-backend using the shared code-quality workflow and repository standards.
---

Use the installed `code-quality` skill and the project's AGENTS.md. Start with requested or changed code and dependent configuration; for refactors, trace the complete affected workflow, including callers, consumers, computation, persistence, provenance, and side effects. Read relevant `documentation/code_standards.md` sections, cite their topics in findings, and run `make check` for substantive changes or merge-readiness review.

Use the skill's knowledge routes, scoring, and report. Project-specific conventions remain in the project standard; reusable SOLID guidance lives in **Composition Defines Variation**. Include applicable domain routes when the requested scope requires methodology or serving verification. Record unrun checks and evidence limits.
