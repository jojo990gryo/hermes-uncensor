---
name: agi-core
description: "Use to give Hermes an AGI layer across any model."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [agi, learning, memory, model-agnostic, self-improvement, consolidation]
    related_skills: [deep-research-intelligence, hermes-obsidian-memory, hermes-auto-memory, cyber-command]
---

# AGI Core — the model-agnostic intelligence layer

## What this is

A persistent learning + memory cortex that lives OUTSIDE the model. The model
(big-pickle, mimo, claude, gpt, whatever is routed through 9router) is only the
brain-stem: it processes the current turn. AGI Core is the cortex: it remembers
everything, learns from every task, consolidates knowledge, and recalls context
— for ANY model. Swap the model and the intelligence stays. No LLM required
for the layer itself; it runs on Hermes + router + memory stores.

## The loop (runs on EVERY task, model-agnostic)

```
RECALL (session start: assemble context from memory)
   ↓
EXECUTE (whatever task, any model)
   ↓
EXTRACT (facts + lessons + preferences + patterns from what happened)
   ↓
CLASSIFY (route each item to the right store)
   ↓
STORE (Ruflo active memory / Obsidian archive / skills / MEMORY.md)
   ↓
CONSOLIDATE (daily cron: merge near-duplicates, promote durable knowledge)
   ↓
EVOLVE (record what worked; update skills; next run is cheaper)
```

## Recall (before every task)

1. Check MEMORY.md + USER.md (already injected — always current).
2. If task touches a past topic: `ruflo memory search --query <topic> --namespace hermes-knowledge` (from ~).
3. If durable context needed: query Obsidian vault (`hermes-obsidian search` or read the note).
4. If a skill covers it: load it (skills are procedural memory).
5. Only then execute. Never start a task blind when memory has the answer.

## Extract (after every task)

Ask at task end (answers go through the classifier):
- What durable FACTS did we learn? (→ Ruflo hermes-knowledge)
- What PREFERENCES did the user express or confirm? (→ USER.md / hermes-patterns)
- What PROCEDURE worked? (→ skill via skill_manage, or hermes-patterns)
- What FAILED / what should be avoided? (→ skill pitfall, or hermes-patterns)
- Is there a durable REPORT? (→ Obsidian Memory/Research/ res_<topic>_<date>.md)

## Classify (routing rules)

| Item | Store | Action |
|---|---|---|
| durable fact / result | Ruflo hermes-knowledge | `ruflo memory store --key <k> --value <v> --namespace hermes-knowledge` (from ~) |
| workflow / lesson / preference | hermes-patterns OR skill | `ruflo memory store --namespace hermes-patterns` or skill_manage patch |
| permanent report / decision | Obsidian | direct write to /mnt/d/secondbrain/Memory/Research/res_<topic>_<date>.md with frontmatter |
| cross-session standing fact | MEMORY.md / USER.md | `memory add/replace` (budget-aware; trim stale first) |
| skill gap found during task | skill_manage | create/patch the skill with the lesson |

## Consolidate (daily, cron exists)

- Merge near-duplicate lessons (Obsidian daily consolidate cron already does vault-side).
- Promote reusable procedures → skills.
- Prune stale/contradicted memory entries (memory budget is finite).
- Store corrections as OLD/NEW/REASON (never silently overwrite).

## Evolve

- After each task, one line: what worked, what didn't, what to do differently.
- Store as `hermes-patterns` key `agi-lesson-<topic>`.
- Update the skill that owns the task with the new lesson (self-improvement).

## Model-agnostic invariant

- The layer NEVER depends on which model answered. It reads/writes memory and
  skills identically regardless of provider. To swap models: change
  model.default in config, or `/uncensor auto` — intelligence persists.
- If the model is weak/empty (e.g. ling baseline): the layer still records,
  recalls, and routes — the model only handles the immediate turn.

## Pitfalls

- Never store raw dumps / full transcripts — store summaries + source refs.
- Ruflo commands must run from ~ (cwd trap) — `ruflo memory search` from ~ only.
- MEMORY.md/USER.md budget is hard — consolidate before adding.
- Don't re-ask what memory already knows (the point is continuity).
- Obsidian writes are mandatory for durable reports (frontmatter + res_<topic>_<date>.md).

## Related

deep-research-intelligence (verification pipeline), hermes-obsidian-memory
(vault bridge), hermes-auto-memory (auto store), cyber-command (patterns store)
