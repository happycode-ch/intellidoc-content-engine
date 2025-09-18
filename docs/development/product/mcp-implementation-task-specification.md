# MCP Implementation Task Specification
**Project**: IntelliDoc Content Engine MCP Transformation
**Date**: September 18, 2025
**Version**: 1.0
**Purpose**: Technical specification for converting 52 Claude Code agents to MCP servers

## Executive Summary

### Problem Statement
The IntelliDoc Content Engine consists of 52 specialized Claude Code agents that currently require manual execution within the Claude Code CLI environment. This limits scalability, automation potential, and SaaS deployment capabilities.

### Solution Overview
Transform the existing agent system into Model Context Protocol (MCP) servers, enabling:
- Platform-agnostic agent execution
- Web UI integration capabilities
- Multi-client connectivity (Claude, ChatGPT, Copilot)
- Automated orchestration without CLI dependency
- Enterprise-grade scalability

### Expected Outcomes
- **Immediate**: Programmatic agent invocation via standard APIs
- **Short-term**: Web-based content creation interface
- **Long-term**: Full SaaS platform with subscription model

## Technical Architecture

### Current State Analysis

#### Agent Structure
```yaml
# Current Claude Code Agent Format
---
name: agent-name
description: agent purpose
model: haiku|sonnet|opus
tools: Read, Write, WebSearch
---

[System prompt in markdown]
```

#### Dependency Chain
```
User → Claude Code CLI → Agent Runtime → Claude API → Tools → Output
```

### Proposed MCP Architecture

#### System Components
```
Web Client → API Gateway → MCP Orchestrator → MCP Servers → Claude/OpenAI API
                                              ↓
                                    Database & File Storage
```

#### MCP Server Structure
```typescript
interface MCPServer {
  name: string;              // Maps to agent name
  version: string;           // Semantic versioning
  capabilities: {
    tools: Tool[];          // Converted from YAML tools
    resources: Resource[];  // File/data access
    prompts: Prompt[];      // Agent templates
  };
  transport: 'stdio' | 'http' | 'websocket';
}
```

## Implementation Approach

### Phase 1: Core MCP Framework (Week 1-2)

#### Deliverable 1.1: Base MCP Server Template
```typescript
// mcp-server-base/src/index.ts
import { Server } from "@modelcontextprotocol/sdk/server";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio";

export class AgentMCPServer extends Server {
  constructor(agentDefinition: AgentConfig) {
    super({
      name: agentDefinition.name,
      version: "1.0.0"
    }, {
      capabilities: {
        tools: {},
        resources: {},
        prompts: {}
      }
    });

    this.loadAgentDefinition(agentDefinition);
  }

  private loadAgentDefinition(config: AgentConfig) {
    // Parse YAML frontmatter
    // Convert tools to MCP tools
    // Load system prompt
  }
}
```

#### Deliverable 1.2: Agent Loader System
```python
# agent_loader.py
import yaml
from pathlib import Path
from typing import Dict, Any

class AgentLoader:
    def __init__(self, agents_dir: Path):
        self.agents_dir = agents_dir

    def load_agent(self, agent_name: str) -> Dict[str, Any]:
        """Load agent definition from markdown file"""
        agent_path = self.agents_dir / f"{agent_name}.md"

        with open(agent_path, 'r') as f:
            content = f.read()

        # Extract YAML frontmatter
        parts = content.split('---')
        metadata = yaml.safe_load(parts[1])
        prompt = '---'.join(parts[2:])

        return {
            'metadata': metadata,
            'prompt': prompt,
            'tools': self.map_tools(metadata.get('tools', []))
        }

    def map_tools(self, claude_tools: list) -> list:
        """Map Claude Code tools to MCP tools"""
        tool_mapping = {
            'Read': 'file_read',
            'Write': 'file_write',
            'WebSearch': 'web_search',
            'WebFetch': 'web_fetch',
            'Bash': 'shell_execute'
        }
        return [tool_mapping.get(tool, tool) for tool in claude_tools]
```

#### Deliverable 1.3: Tool Adapter Layer
```typescript
// tool-adapters/index.ts
export class ToolAdapter {
  static async executeRead(path: string): Promise<string> {
    // Implement file reading logic
    return await fs.readFile(path, 'utf-8');
  }

  static async executeWrite(path: string, content: string): Promise<void> {
    // Implement file writing logic
    await fs.writeFile(path, content);
  }

  static async executeWebSearch(query: string): Promise<SearchResult[]> {
    // Implement web search via API
    return await searchAPI.search(query);
  }
}
```

### Phase 2: Agent Conversion (Week 3-6)

#### Deliverable 2.1: Individual Agent MCP Servers

##### Example: body-writer MCP Server
```python
# servers/body-writer/server.py
from mcp.server.fastmcp import FastMCP
from typing import Dict, Any
import anthropic

mcp = FastMCP("body-writer")
client = anthropic.Client()

@mcp.tool()
async def write_body_content(
    outline: str,
    research_document: Dict[str, Any],
    tone: str,
    word_target: int = 1000
) -> Dict[str, Any]:
    """Write main content sections with examples and evidence"""

    # Load agent prompt template
    prompt = load_agent_prompt("body-writer")

    # Format input for Claude
    formatted_input = {
        "outline": outline,
        "research_document": research_document,
        "tone": tone,
        "word_target": word_target
    }

    # Execute via Claude API
    response = await client.messages.create(
        model="claude-3-5-sonnet-20241022",
        messages=[
            {"role": "system", "content": prompt},
            {"role": "user", "content": json.dumps(formatted_input)}
        ]
    )

    # Parse and return response
    return json.loads(response.content)
```

##### Example: keyword-researcher MCP Server
```typescript
// servers/keyword-researcher/index.ts
import { FastMCP } from '@modelcontextprotocol/fastmcp';

const server = new FastMCP('keyword-researcher');

server.tool('research_keywords', async (params: {
  topic: string;
  target_audience: string;
  content_type: string;
}) => {
  // Load agent definition
  const agentPrompt = await loadAgentPrompt('keyword-researcher');

  // Execute search operations
  const searchResults = await performWebSearch(params.topic);

  // Process through Haiku model
  const keywords = await processWithClaude({
    model: 'claude-3-haiku-20240307',
    prompt: agentPrompt,
    input: {
      topic: params.topic,
      target_audience: params.target_audience,
      search_results: searchResults
    }
  });

  return {
    primary_keyword: keywords.primary,
    long_tail: keywords.long_tail,
    search_volume: keywords.volume,
    difficulty: keywords.difficulty
  };
});
```

#### Deliverable 2.2: Orchestration MCP Servers

##### Blog Post Orchestrator Implementation
```python
# servers/blog-post-orchestrator/server.py
from mcp.server.fastmcp import FastMCP
from mcp_client import MCPClient
import asyncio

mcp = FastMCP("blog-post-orchestrator")

# Define agent pipeline
PIPELINE = {
    "phase1_research": [
        "topic-scout",
        "source-gatherer",
        "competitor-analyzer",
        "fact-verifier",
        "keyword-researcher"
    ],
    "phase2_planning": [
        "audience-profiler",
        "angle-definer",
        "template-selector",
        "spec-writer"
    ],
    "phase3_creation": [
        "outline-builder",
        "intro-writer",
        "body-writer",
        "code-example-writer",
        "conclusion-writer",
        "content-assembler"
    ],
    "phase4_quality": [
        "grammar-checker",
        "style-editor",
        "flow-optimizer",
        "link-validator"
    ]
}

@mcp.tool()
async def create_blog_post(topic: str, requirements: dict) -> dict:
    """Orchestrate complete blog post creation"""

    context = {
        "topic": topic,
        "requirements": requirements,
        "outputs": {}
    }

    # Execute pipeline phases
    for phase_name, agents in PIPELINE.items():
        print(f"Executing {phase_name}...")

        for agent_name in agents:
            # Connect to agent's MCP server
            client = MCPClient(f"mcp://{agent_name}")

            # Prepare agent input from context
            agent_input = prepare_input_for_agent(agent_name, context)

            # Execute agent
            result = await client.invoke_tool(
                f"{agent_name}_execute",
                agent_input
            )

            # Store result in context
            context["outputs"][agent_name] = result

    # Return final assembled content
    return context["outputs"]["content-assembler"]

def prepare_input_for_agent(agent_name: str, context: dict) -> dict:
    """Map context to specific agent input format"""

    input_mapping = {
        "topic-scout": lambda ctx: {"topic": ctx["topic"]},
        "body-writer": lambda ctx: {
            "outline": ctx["outputs"]["outline-builder"],
            "research_document": ctx["outputs"]["source-gatherer"],
            "tone": ctx["requirements"].get("tone", "professional")
        },
        "content-assembler": lambda ctx: {
            "fragments": {
                "introduction": ctx["outputs"]["intro-writer"],
                "body_sections": ctx["outputs"]["body-writer"],
                "conclusion": ctx["outputs"]["conclusion-writer"]
            }
        }
    }

    return input_mapping.get(agent_name, lambda x: x)(context)
```

#### Deliverable 2.3: MCP Server Registry
```json
{
  "servers": {
    "content-creation": {
      "orchestrators": [
        "blog-post-orchestrator",
        "tutorial-orchestrator",
        "whitepaper-orchestrator",
        "news-orchestrator",
        "social-media-orchestrator",
        "series-orchestrator"
      ],
      "research": [
        "topic-scout",
        "source-gatherer",
        "competitor-analyzer",
        "fact-verifier",
        "keyword-researcher"
      ],
      "writing": [
        "body-writer",
        "intro-writer",
        "conclusion-writer",
        "content-assembler"
      ],
      "quality": [
        "grammar-checker",
        "style-editor",
        "flow-optimizer"
      ]
    }
  }
}
```

### Phase 3: Web Interface Integration (Week 7-8)

#### Deliverable 3.1: API Gateway
```python
# api/main.py
from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel
import uuid

app = FastAPI()

class ContentRequest(BaseModel):
    content_type: str  # blog, tutorial, whitepaper, etc.
    topic: str
    requirements: dict

class JobStatus(BaseModel):
    job_id: str
    status: str  # pending, processing, completed, failed
    progress: dict
    result: dict = None

@app.post("/content/create")
async def create_content(
    request: ContentRequest,
    background_tasks: BackgroundTasks
):
    """Submit content creation request"""

    job_id = str(uuid.uuid4())

    # Queue job for processing
    background_tasks.add_task(
        process_content_request,
        job_id,
        request
    )

    return {"job_id": job_id, "status": "queued"}

@app.get("/content/status/{job_id}")
async def get_status(job_id: str) -> JobStatus:
    """Check job status and retrieve results"""

    job = await get_job_from_database(job_id)

    return JobStatus(
        job_id=job_id,
        status=job["status"],
        progress=job["progress"],
        result=job.get("result")
    )

async def process_content_request(job_id: str, request: ContentRequest):
    """Process content creation via MCP orchestrator"""

    # Update job status
    await update_job_status(job_id, "processing")

    try:
        # Connect to appropriate orchestrator
        orchestrator = f"{request.content_type}-orchestrator"
        client = MCPClient(f"mcp://{orchestrator}")

        # Execute content creation
        result = await client.invoke_tool(
            "create_content",
            {
                "topic": request.topic,
                **request.requirements
            }
        )

        # Store result
        await update_job_status(
            job_id,
            "completed",
            result=result
        )

    except Exception as e:
        await update_job_status(
            job_id,
            "failed",
            error=str(e)
        )
```

#### Deliverable 3.2: Frontend Client
```typescript
// frontend/src/ContentCreator.tsx
import React, { useState } from 'react';
import { ContentAPI } from './api';

export const ContentCreator: React.FC = () => {
  const [jobId, setJobId] = useState<string | null>(null);
  const [status, setStatus] = useState<any>(null);

  const handleSubmit = async (formData: ContentRequest) => {
    // Submit request to API
    const response = await ContentAPI.createContent(formData);
    setJobId(response.job_id);

    // Poll for status
    pollStatus(response.job_id);
  };

  const pollStatus = async (id: string) => {
    const interval = setInterval(async () => {
      const status = await ContentAPI.getStatus(id);
      setStatus(status);

      if (status.status === 'completed' || status.status === 'failed') {
        clearInterval(interval);
      }
    }, 2000);
  };

  return (
    <div>
      <ContentForm onSubmit={handleSubmit} />
      {status && <StatusDisplay status={status} />}
      {status?.result && <ContentDisplay content={status.result} />}
    </div>
  );
};
```

## Testing Strategy

### Unit Tests
```python
# tests/test_body_writer.py
import pytest
from servers.body_writer import write_body_content

@pytest.mark.asyncio
async def test_body_writer_basic():
    result = await write_body_content(
        outline="1. Introduction\n2. Main Point\n3. Conclusion",
        research_document={"sources": []},
        tone="professional",
        word_target=500
    )

    assert "body_content" in result
    assert result["word_count"] >= 450
    assert result["word_count"] <= 550
```

### Integration Tests
```python
# tests/test_orchestration.py
@pytest.mark.asyncio
async def test_blog_post_pipeline():
    orchestrator = MCPClient("mcp://blog-post-orchestrator")

    result = await orchestrator.invoke_tool(
        "create_blog_post",
        {
            "topic": "Docker best practices",
            "requirements": {"tone": "technical"}
        }
    )

    assert "final_content" in result
    assert len(result["final_content"]) > 1000
```

### Performance Benchmarks
```yaml
performance_targets:
  blog_post:
    max_duration: 900s  # 15 minutes
    min_quality_score: 0.8
  tutorial:
    max_duration: 1800s  # 30 minutes
    min_quality_score: 0.85
  individual_agent:
    max_response_time: 30s
    max_memory_usage: 512MB
```

## Configuration Examples

### Claude Desktop Configuration
```json
{
  "mcpServers": {
    "intellidoc-blog": {
      "command": "python",
      "args": [
        "/path/to/servers/blog-post-orchestrator/server.py"
      ]
    },
    "intellidoc-body-writer": {
      "command": "node",
      "args": [
        "/path/to/servers/body-writer/index.js"
      ]
    }
  }
}
```

### Docker Compose Deployment
```yaml
version: '3.8'

services:
  api-gateway:
    image: intellidoc/api-gateway:latest
    ports:
      - "8000:8000"
    environment:
      - MCP_SERVERS=redis://redis:6379

  blog-orchestrator:
    image: intellidoc/blog-orchestrator:latest
    environment:
      - CLAUDE_API_KEY=${CLAUDE_API_KEY}
      - MCP_TRANSPORT=redis

  body-writer:
    image: intellidoc/body-writer:latest
    environment:
      - MODEL=claude-3-5-sonnet
      - MCP_TRANSPORT=redis

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
```

## Implementation Timeline

### Week 1-2: Foundation
- [ ] Set up TypeScript/Python MCP SDK environments
- [ ] Create base MCP server template
- [ ] Implement agent loader system
- [ ] Build tool adapter layer
- [ ] Test with 1 simple agent (keyword-researcher)

### Week 3-4: Core Agents
- [ ] Convert research agents (5)
- [ ] Convert planning agents (5)
- [ ] Convert writing agents (5)
- [ ] Test individual agent functionality

### Week 5-6: Orchestration
- [ ] Implement blog-post-orchestrator
- [ ] Implement tutorial-orchestrator
- [ ] Build agent chaining logic
- [ ] Test end-to-end workflows

### Week 7: API & Infrastructure
- [ ] Deploy API gateway
- [ ] Set up job queue system
- [ ] Implement status tracking
- [ ] Configure Docker containers

### Week 8: Web Interface
- [ ] Build frontend components
- [ ] Implement real-time status updates
- [ ] Add authentication
- [ ] User acceptance testing

## Risk Assessment

### Technical Risks

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Agent prompt extraction complexity | High | Medium | Build automated parser with fallback to manual |
| MCP orchestration latency | Medium | High | Implement caching and parallel execution |
| Tool compatibility issues | High | Low | Maintain compatibility layer |
| API rate limiting | Medium | Medium | Implement queuing and retry logic |

### Dependencies
- Claude API availability and pricing
- MCP SDK stability (currently v1.0)
- Network latency for orchestration
- File system access permissions

### Performance Considerations
- **Baseline**: Current manual execution 8-40 minutes
- **Target**: Automated execution within same timeframe
- **Optimization**: Cache research results, parallel QA checks
- **Monitoring**: Track API costs per content piece

## Security Specifications

### API Security
```python
# Authentication middleware
from fastapi_jwt_auth import AuthJWT

@app.post("/content/create")
@require_auth
async def create_content(
    request: ContentRequest,
    Authorize: AuthJWT = Depends()
):
    current_user = Authorize.get_jwt_subject()
    # Process request with user context
```

### MCP Server Security
- Transport encryption (TLS for HTTP/WebSocket)
- API key management via environment variables
- Input validation on all agent inputs
- Output sanitization before storage

## Monitoring & Observability

### Logging Strategy
```python
import structlog

logger = structlog.get_logger()

@mcp.tool()
async def agent_execute(input_data: dict):
    logger.info(
        "agent_execution_started",
        agent="body-writer",
        input_size=len(str(input_data))
    )

    # Agent logic...

    logger.info(
        "agent_execution_completed",
        agent="body-writer",
        duration=execution_time,
        output_size=len(str(result))
    )
```

### Metrics Collection
```yaml
metrics:
  - name: content_creation_duration
    type: histogram
    labels: [content_type, orchestrator]
  - name: agent_execution_time
    type: histogram
    labels: [agent_name, model]
  - name: api_requests_total
    type: counter
    labels: [endpoint, status]
```

## Success Criteria

### Functional Requirements
- ✅ All 52 agents converted to MCP servers
- ✅ Orchestrators successfully chain agent execution
- ✅ Web API accepts and processes requests
- ✅ Results match current quality standards

### Non-Functional Requirements
- ✅ Blog post generation < 15 minutes
- ✅ System handles 10 concurrent requests
- ✅ 99% uptime for production deployment
- ✅ API response time < 500ms

### Business Metrics
- ✅ Reduce manual operation time by 80%
- ✅ Enable 24/7 content generation capability
- ✅ Support multiple clients simultaneously
- ✅ Maintain content quality scores > 0.8

## Appendix A: Agent Conversion Checklist

For each agent:
1. [ ] Extract YAML frontmatter
2. [ ] Map tools to MCP equivalents
3. [ ] Convert prompt to MCP tool description
4. [ ] Implement input/output schemas
5. [ ] Create unit tests
6. [ ] Document API interface
7. [ ] Update registry

## Appendix B: Useful Resources

### Documentation
- [MCP Specification](https://modelcontextprotocol.io/docs)
- [MCP TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)
- [MCP Python SDK](https://github.com/modelcontextprotocol/python-sdk)
- [FastMCP Framework](https://github.com/jlowin/fastmcp)

### Example Repositories
- [MCP Servers Collection](https://github.com/modelcontextprotocol/servers)
- [Awesome MCP Servers](https://github.com/punkpeye/awesome-mcp-servers)
- [MCP Agent Framework](https://github.com/lastmile-ai/mcp-agent)

### Tools & Libraries
- TypeScript: `@modelcontextprotocol/sdk`
- Python: `mcp`, `fastmcp`
- Testing: `pytest`, `jest`
- API: `FastAPI`, `Express`

## Appendix C: Sample Agent Conversion

### Original Claude Code Agent
```yaml
---
name: fact-verifier
description: Validate claims, statistics, and technical accuracy
model: haiku
tools: WebSearch, WebFetch
---

You are a fact-checker validating information accuracy...
```

### Converted MCP Server
```python
# servers/fact-verifier/server.py
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("fact-verifier")

@mcp.tool()
async def verify_facts(
    claims: list[str],
    sources: list[str] = None
) -> dict:
    """Validate claims, statistics, and technical accuracy"""

    verification_results = []

    for claim in claims:
        # Search for supporting evidence
        search_results = await web_search(claim)

        # Fetch relevant pages
        if sources:
            page_content = await web_fetch(sources[0])

        # Verify with Haiku model
        result = await verify_with_claude(
            claim=claim,
            evidence=search_results,
            model="claude-3-haiku-20240307"
        )

        verification_results.append(result)

    return {
        "verified_claims": verification_results,
        "accuracy_score": calculate_accuracy(verification_results)
    }
```

---

*This specification provides a complete roadmap for transforming the IntelliDoc Content Engine into a modern MCP-based architecture, enabling web deployment while maintaining the sophisticated multi-agent orchestration that makes the system valuable.*