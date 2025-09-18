Prompt request: Create a clean, accurate, implementation-ready spec (v2) to convert 52 Claude Code agents into an MCP‑based system, with elegant design, minimal moving parts, and correct use of the MCP standard.

IntelliDoc Content Engine — MCP Implementation Spec (v2)

Date: 18 Sep 2025
Author: CTO review version
Purpose: Replace 52 CLI‑driven Claude Code agents with a durable, MCP‑native architecture suitable for local use (Claude Desktop/Copilot), remote orchestration, and a SaaS UI.

TL;DR

Feasible and recommended. Use standard MCP transports only: stdio (local) and Streamable HTTP (remote). No WebSocket/Redis transports—those aren’t part of MCP. 
Model Context Protocol
+1

Consolidate 52 agents into 4 domain MCP servers (Research, Writing, Quality, Templates) that expose multiple tools each; add a single Orchestrator that is both MCP server (one orchestration tool) and MCP client (to the domain servers).

Clients supported now: Claude Desktop/Code (stdio & remote HTTP + OAuth), ChatGPT custom connectors (MCP; Pro/Plus availability limited in EEA/CH/UK), GitHub Copilot in VS Code (broad MCP features, incl. tools/resources/prompts). Plan accordingly. 
Anthropic
+2
OpenAI Help Center
+2

Production shape: FastAPI + durable queue (Celery/RQ) for jobs, Postgres + object storage for artifacts, metrics & tracing.

Outcome: Same or faster throughput vs. manual runs; cleaner ops; multi‑client access; clear upgrade path to SaaS.

0) Grounding / Research (what we’re aligning to)

MCP transports: stdio (local) and Streamable HTTP (remote, with optional SSE fallback). SSE is deprecated in favor of Streamable HTTP; enable CORS and expose Mcp-Session-Id for browser clients. 
GitHub

TypeScript SDK: Use McpServer, registerTool/Resource/Prompt, StdioServerTransport, StreamableHTTPServerTransport. 
GitHub

Python SDK (FastMCP & low‑level): Build servers & clients, mount Streamable HTTP under ASGI, configure CORS to expose Mcp-Session-Id. Client usage via ClientSession + streamablehttp_client(...). 
GitHub

Claude Code / Desktop: stdio & remote (HTTP/SSE) servers, OAuth for remote, .mcp.json/Desktop config supported. 
Anthropic
+1

ChatGPT (Custom connectors / MCP): supported; Pro/Plus not available in EEA/CH/UK (Business/Enterprise/Edu ok). 
OpenAI Help Center

GitHub Copilot / VS Code: supports MCP servers (tools/resources/prompts, transports include stdio & HTTP). 
Visual Studio Code

Community servers we can reuse: Filesystem, Fetch (web retrieval), GitHub, etc., to avoid reinventing adapters. 
Model Context Protocol
+2
GitHub
+2

1) Goals & Non‑Goals

Goals

Convert the 52 agents into domain MCP servers with typed tools and prompts.

Provide an Orchestrator that runs pipelines (blog/tutorial/whitepaper) by calling domain tools in parallel where safe.

Expose a durable API and a minimal web UI for job submission/status/results.

Keep local developer UX first‑class (Claude Desktop/VS Code).

Non‑Goals

No custom transports (e.g., Redis/WebSocket). Use only stdio/Streamable HTTP per spec. 
Model Context Protocol

No monolithic single process with 52 binaries; consolidate wisely.

2) High‑Level Architecture
Clients (Claude Desktop, ChatGPT, Copilot, Web UI)
            │
            │ stdio (local) / Streamable HTTP (remote)
            ▼
      Domain MCP Servers (4)
      ┌──────────────────────────────────────────────┐
      │ research-server   writing-server             │
      │ quality-server    templates-server           │
      └──────────────────────────────────────────────┘
            ▲                ▲
            │ Streamable HTTP│
            │                │
            └────── Orchestrator (MCP server + client) ──► LLM APIs (Anthropic/OpenAI)
                             │
                             ├─ Job Queue (Redis-backed)
                             ├─ Postgres (jobs, metadata)
                             └─ Object Storage (artifacts)


Why Streamable HTTP: remote, multi‑client, stateful sessions; CORS & Mcp-Session-Id supported; SSE only for legacy fallback. 
GitHub

3) Server Consolidation (from 52 → 4 domain servers)

A. research-server

Tools: topic_scout, source_gatherer, competitor_analyzer, fact_verifier, keyword_researcher

Reuse fetch server where possible for web retrieval; wrap post‑processing logic in our tools. 
GitHub Docs

B. writing-server

Tools: outline_builder, intro_writer, body_writer, code_example_writer, conclusion_writer, content_assembler

C. quality-server

Tools: grammar_check, style_edit, flow_optimize, link_validate

D. templates-server

Prompts/specs: reusable prompt templates, content schemas, voice presets exposed via MCP prompts.

Benefits: fewer containers/processes, faster startup, simpler config, shared caches per domain.

4) Orchestrator Design

Runs as an MCP server exposing one or more orchestration tools, e.g.:

create_blog_post(topic, requirements) -> content_bundle

create_tutorial(topic, requirements) -> content_bundle

Also runs as an MCP client to domain servers via ClientSession + streamablehttp_client(...). 
GitHub

Performs parallel steps (e.g., research fan‑out), merges results, retries transient failures, and enforces structured outputs.

Pipeline Example (blog)

Research (parallel): topic_scout, source_gatherer, competitor_analyzer, keyword_researcher

Plan: outline_builder

Draft: intro_writer, body_writer, code_example_writer, conclusion_writer

Assemble: content_assembler

Quality (parallel): grammar_check, style_edit, flow_optimize, link_validate

5) Repository Layout (monorepo)
/intellidoc
  /servers
    /research-server      (Python FastMCP)
    /writing-server       (Python FastMCP)
    /quality-server       (Python FastMCP)
    /templates-server     (Python FastMCP)
  /orchestrator           (Python, FastMCP server + MCP client)
  /api                    (FastAPI + Celery/RQ workers)
  /frontend               (React minimal UI)
  /ops                    (Dockerfiles, compose, k8s manifests)
  /tests                  (unit, contract, integration, perf)
  /scripts                (conversion tools, load testing)


You can implement servers in TS using the TS SDK as well; we recommend one language for servers to keep ops simple.

6) Implementation Details
6.1 MCP Servers (Python, FastMCP)

Server skeleton (Streamable HTTP + stdio for dev):

# servers/writing-server/server.py
from mcp.server.fastmcp import FastMCP
from typing import TypedDict

mcp = FastMCP("writing-server", version="1.0.0")

class BodyInput(TypedDict):
    outline: str
    research_document: dict
    tone: str
    word_target: int

class BodyOutput(TypedDict):
    body_content: str
    word_count: int

@mcp.tool()
def write_body_content(input: BodyInput) -> BodyOutput:
    # Call LLM (Anthropic/OpenAI) with your prompt templates
    # Return structured output; FastMCP will marshal to MCP
    text = "..."   # <- generated text
    return {"body_content": text, "word_count": len(text.split())}

if __name__ == "__main__":
    # stdio for local dev / Claude Desktop
    # uv run python servers/writing-server/server.py
    mcp.run_stdio()


FastMCP and Python SDK features are documented, including Streamable HTTP mounting and CORS (Mcp-Session-Id). 
GitHub

TypeScript alternative (if chosen):

// servers/writing-server/index.ts
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({ name: "writing-server", version: "1.0.0" });

server.registerTool(
  "write_body_content",
  {
    title: "Write body",
    description: "Generate main content sections with evidence",
    inputSchema: {
      outline: z.string(),
      research_document: z.record(z.any()),
      tone: z.string().default("professional"),
      word_target: z.number().int().positive().max(3000).default(1000)
    }
  },
  async ({ outline, research_document, tone, word_target }) => {
    // call your LLM and return MCP content blocks or links
    return { content: [{ type: "text", text: "..." }] };
  }
);

await server.connect(new StdioServerTransport());


(Uses McpServer & registerTool correctly.) 
GitHub

Transport (remote): expose Streamable HTTP under /mcp (Starlette/FastAPI mount), and expose Mcp-Session-Id in CORS. 
GitHub
+1

6.2 Orchestrator (Python server + client)
# orchestrator/server.py
from mcp.server.fastmcp import FastMCP
from mcp import ClientSession
from mcp.client.streamable_http import streamablehttp_client
import asyncio

mcp = FastMCP("orchestrator", version="1.0.0")

async def call_tool(url: str, tool: str, args: dict):
    async with streamablehttp_client(url) as (r, w, _):
        async with ClientSession(r, w) as session:
            await session.initialize()
            return await session.call_tool(tool, arguments=args)

@mcp.tool()
async def create_blog_post(topic: str, requirements: dict) -> dict:
    # Phase 1: parallel research
    research_urls = {
      "topic_scout": "https://research.example.com/mcp",
      "source_gatherer": "https://research.example.com/mcp",
      "keyword_researcher": "https://research.example.com/mcp"
    }
    tasks = [
      call_tool(research_urls["topic_scout"], "topic_scout", {"topic": topic}),
      call_tool(research_urls["source_gatherer"], "source_gatherer", {"topic": topic}),
      call_tool(research_urls["keyword_researcher"], "keyword_researcher", {"topic": topic})
    ]
    scout, sources, keywords = await asyncio.gather(*tasks)

    # Phase 2..N: plan, draft, assemble, quality similarly...
    # Return a structured content bundle
    return {"topic": topic, "scout": scout, "sources": sources, "keywords": keywords}


(Uses official client & Streamable HTTP; no mcp:// pseudo‑URIs.) 
AWS Documentation

6.3 LLM Calls (Anthropic example)
from anthropic import Anthropic
client = Anthropic()  # API key from env

msg = client.messages.create(
    model="claude-sonnet-4-20250514",   # or env-configured alias
    max_tokens=1200,
    messages=[{"role": "user", "content": "Write section X ..."}],
)
text = "".join(
    block.text for block in msg.content
    if getattr(block, "type", "") == "text"
)


(Use current messages API; content is a list of blocks.) 
Anthropic

Prefer vendor “latest” aliases in config; keep model IDs configurable.

7) API Gateway & Web UI

API (FastAPI)

POST /content/create → enqueue job (Celery/RQ)

GET /content/status/{job_id} → progress, logs, result

GET /content/stream/{job_id} (optional SSE) → live updates

Job processing

Worker acquires orchestrator tool (local stdio or remote HTTP), runs pipeline, persists artifacts (drafts, outlines, citations) in object storage (S3/Blob/GCS), writes metadata in Postgres.

Auth

JWT for UI/API; OAuth used only when required by remote MCP servers. Claude Code remote servers also support OAuth. 
Anthropic

Frontend

Minimal React app: submit form → poll or SSE → render content bundle.

8) Configuration & Clients

Claude Desktop (local stdio)

{
  "mcpServers": {
    "orchestrator": {
      "command": "uv",
      "args": ["run", "orchestrator/server.py"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    }
  }
}


(Official Desktop config pattern.) 
Model Context Protocol

ChatGPT custom connector

Supported via MCP; Pro/Plus: not currently available in EEA/CH/UK; use Business/Enterprise/Edu if you need this in CH. 
OpenAI Help Center

GitHub Copilot (VS Code)

Add servers via VS Code MCP config; supports stdio & HTTP, and MCP features incl. tools/resources/prompts. 
Visual Studio Code

9) Data, Cost & Performance

Caching: Persist research fetches keyed by URL+hash; reuse across jobs to cut latency & cost. Use TTL for freshness.

Parallelism: Fan‑out research and quality passes; cap concurrency to respect API limits.

Cost controls: Capture token usage per tool invocation; budget per job; fail fast on runaway costs.

Targets: Blog < 15 min; 10 concurrent jobs on a single worker node with backpressure; structured outputs for deterministic assembly.

10) Security

Transports: stdio (local), Streamable HTTP (remote). Enable DNS rebinding protection and allow‑list hosts for local servers; expose Mcp-Session-Id in CORS for browser clients. 
GitHub

Secrets: Per‑server env; rotate via CI/CD.

Input validation: zod (TS) / Pydantic (Py).

Sandboxing: Limit filesystem roots via server‑filesystem args; treat fetch content as untrusted (prompt‑injection risk). 
Model Context Protocol

11) Testing & Quality

Unit tests

Pure functions & LLM call wrappers (mock Anthropic/OpenAI).

Tool schema contract tests (input/output validation).

Integration

Spin up domain servers (stdio) + orchestrator; run end‑to‑end pipelines with fixture topics.

Contract checks

Verify list_tools, list_resources, list_prompts against our registry; run MCP Inspector locally. 
Model Context Protocol

Perf

Track p95 tool latency, tokens/job, cost/job; assert SLOs in CI nightly.

12) Deployment

Local dev: stdio via Desktop/VS Code; uv run ... for Python servers. 
GitHub

Remote: Containers behind HTTPS; Streamable HTTP at /mcp with CORS exposing Mcp-Session-Id. 
GitHub

Docker Compose (minimal)

version: "3.8"
services:
  api:
    build: ./api
    ports: ["8000:8000"]
    environment:
      - DATABASE_URL=postgres://...
      - REDIS_URL=redis://redis:6379
  orchestrator:
    build: ./orchestrator
    environment:
      - SERVER_BIND=:8080
  research:
    build: ./servers/research-server
  writing:
    build: ./servers/writing-server
  quality:
    build: ./servers/quality-server
  templates:
    build: ./servers/templates-server
  redis:
    image: redis:alpine
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD: example


Redis here is for jobs/caching, not as an MCP transport.

13) Migration (from 52 agents)

Automated conversion script (front‑matter → tool definitions)

Parse Markdown (--- YAML + prompt body).

Map tool names to domain servers.

Generate tool stubs (input/output schemas) + test skeletons.

Checklist per agent

Extract front‑matter → name, description, tools

Assign to domain server; define prompt(s) as MCP prompts

Define tool schema (I/O) & deterministic outputs

Implement with vendor‑agnostic LLM wrapper

Unit & contract tests; add to server registry

Add to orchestrator pipeline

14) Deliverables & Timeline (8 weeks, lean)

Week 1–2 — Foundation

Repos, CI, domain server skeletons (2), orchestrator POC (list_tools, call_tool), API stub, Desktop/VS Code configs working locally.

Week 3–4 — Domain tools

Research + Writing servers complete (core 10–12 tools), Templates server, caching, cost logging.

Week 5–6 — Orchestration

Full blog/tutorial pipelines; parallelism; retries; quality server; E2E tests.

Week 7 — API/UI & Ops

Durable queue, auth, status/SSE, metrics/tracing, basic React UI.

Week 8 — Hardening

Perf/cost passes, security review, canary deploy, UAT.

15) Risks & Mitigations
Risk	Impact	Prob	Mitigation
Transport misuse	High	Low	Only stdio/Streamable HTTP; SSE fallback if needed. 
GitHub

Client variances (ChatGPT availability in CH)	Med	Med	Plan for Claude/Copilot first; target ChatGPT Business/Enterprise if needed. 
OpenAI Help Center

Cost/latency spikes	Med	Med	Parallelize safely; cache; cap tokens; budget per job.
Prompt injection via web	Med	Med	Use fetch server carefully; sanitize; source pinning; human‑in‑the‑loop for outbound links.
Vendor model churn	Med	Med	Use env‑configured model aliases; test weekly.
16) Success Criteria

Functional

Domain servers enumerate correct tools/prompts/resources; orchestrator composes pipelines and returns a structured bundle.

Non‑functional

Blog post pipeline p95 < 15 min; ≥10 concurrent jobs with backpressure & retries.

Business

80% reduction in manual ops time; web access for internal alpha users; per‑job cost visibility.

17) Reference Code (copy‑paste safe)

TS server (stdio): shows McpServer, registerTool, correct imports. 
GitHub

Python FastMCP server/client: shows FastMCP, ClientSession, streamablehttp_client. 
GitHub

Claude Desktop config: canonical pattern for local servers & community filesystem server. 
Model Context Protocol

Appendix — Pinned References

Spec & transports: stdio & Streamable HTTP (SSE legacy/deprecated content + CORS & Mcp-Session-Id). 
Model Context Protocol
+1

TS SDK server/client examples (registerTool, Streamable HTTP server): 
GitHub

Python SDK (FastMCP, HTTP mount, client, CORS): 
GitHub

Claude Code MCP (OAuth, config, SSE/HTTP/stdio): 
Anthropic

ChatGPT custom connectors availability (EEA/CH/UK limits for Pro/Plus): 
OpenAI Help Center

Copilot VS Code MCP support: 
Visual Studio Code

Filesystem/Fetch servers (reuse): 
Model Context Protocol
+1

Anthropic Messages API (content blocks) & model IDs: 
Anthropic

Final notes (CTO stance)

This spec removes incorrect transports, standardizes server creation, and minimizes process count without sacrificing modularity.

If we implement only the Research & Writing servers + Orchestrator in the first two weeks, we’ll already unlock web‑based content generation and multi‑client support.

From there, quality passes & UI are incremental. The highest leverage is orchestration reliability + caching + cost controls.

If you want, I can generate:

a scaffold repo (monorepo layout + build files),

starter servers (Research/Writing) with working registerTool/FastMCP examples, and

a minimal FastAPI + Celery job runner wired to the Orchestrator.

Spec & transports: stdio & Streamable HTTP (SSE legacy/deprecated content + CORS & Mcp-Session-Id)
- https://modelcontextprotocol.io/specification/2025-03-26
- https://modelcontextprotocol.io/specification/2025-03-26/basic/transports
- https://modelcontextprotocol.io/legacy/concepts/transports
- https://spec.modelcontextprotocol.io/

TS SDK server/client examples (registerTool, Streamable HTTP server)
- https://github.com/modelcontextprotocol/typescript-sdk

Python SDK (FastMCP, HTTP mount, client, CORS)
- https://github.com/modelcontextprotocol/python-sdk
- https://github.com/jlowin/fastmcp

Claude Code MCP (OAuth, config, SSE/HTTP/stdio)
- https://docs.anthropic.com/en/docs/claude-code/mcp
- https://docs.anthropic.com/en/docs/agents-and-tools/mcp-connector
- https://docs.anthropic.com/en/docs/agents-and-tools/remote-mcp-servers
- https://modelcontextprotocol.io/quickstart/server  (Desktop config quickstart)

ChatGPT custom connectors availability (EEA/CH/UK limits for Plus/Pro)
- https://help.openai.com/en/articles/11487775-connectors-in-chatgpt
- https://help.openai.com/en/articles/6825453-chatgpt-release-notes
- https://help.openai.com/en/articles/11367239-connect-apps-to-chatgpt-deep-research

Copilot VS Code MCP support
- https://code.visualstudio.com/docs/copilot/customization/mcp-servers
- https://code.visualstudio.com/updates/v1_100
- https://code.visualstudio.com/updates/v1_101
- https://docs.github.com/copilot/customizing-copilot/using-model-context-protocol/extending-copilot-chat-with-mcp

Filesystem/Fetch servers (reuse)
- https://github.com/modelcontextprotocol/servers
- https://www.npmjs.com/package/@modelcontextprotocol/server-filesystem
  (Fetch is included in the servers repo under /src/fetch)

Anthropic Messages API (content blocks) & model IDs
- https://docs.anthropic.com/en/api/messages
- https://docs.claude.com/en/docs/about-claude/models/overview
