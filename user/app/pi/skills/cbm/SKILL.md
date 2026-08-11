---
name: cbm
description: Query a pre-built knowledge graph of the codebase (functions, classes, call chains, imports) instead of exploring file-by-file. Use for structural questions — who calls X, what breaks if Y changes, where is Z defined, architecture overviews.
---

# codebase-memory (cbm)

A local code-intelligence graph. One query often replaces a dozen grep/read
cycles. Everything runs locally via one-shot CLI calls:

    codebase-memory-mcp cli <tool> '<json-args>'

stderr carries BOTH `level=info` progress logs (ignore those) AND error
messages with usage hints (read those) — never redirect stderr away
(`2>/dev/null` hides the hints that tell you the correct arguments).

## Session start

1. `codebase-memory-mcp cli list_projects '{}'` — find the project slug for
   the current repo (matches its absolute path).
2. If the repo isn't listed, index it (fast — under a second for ~500 files):
   `codebase-memory-mcp cli index_repository '{"repo_path": "<ABS_REPO_PATH>"}'`
3. All other tools take the slug: `{"project": "<slug>", ...}`.

## Tools

- `search_graph` — find symbols by name/relevance:
  `'{"project": "<slug>", "query": "formatDate"}'`
  → qualified_name, file_path, start/end lines per hit.
- `trace_path` — call/dependency chains between nodes.
- `query_graph` — Cypher-style graph queries for complex relationships.
  Use SINGLE-quoted string literals inside the Cypher
  (`{name: 'formatDate'}`) — escaped double quotes (`\"`) break the
  argument parser and surface as a misleading "query is required".
  Example that works:
  `'{"project": "<slug>", "query": "MATCH (caller)-[:CALLS]->(f {name: '"'"'formatDate'"'"'}) RETURN caller.name, caller.file_path"}'`
- `get_architecture` — module/layer overview of the codebase.
- `search_code` — full-text search over indexed content.
- `get_code_snippet` — fetch a node's source by graph identity.
- `detect_changes` / `index_status` — check freshness; re-run
  `index_repository` after large edits (re-indexing is cheap).
- `get_graph_schema` — node/edge types available to queries.

Argument shapes beyond the ones shown: call with `'{}'` and follow the
error's hint — errors are self-documenting and list what's required.

## When to use

Reach for the graph FIRST when the question is structural: "who calls this",
"what are all consumers of X", "what breaks if I change this signature",
"how do these modules relate", "where is this defined/used". Fall back to
grep/read for single known files or non-code content. After you finish a
multi-file change, re-index so later queries see your edits.
