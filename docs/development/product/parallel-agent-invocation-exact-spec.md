# Exact Parallel Agent Invocation Specification

## Overview
This document contains the exact specification and code pattern used to successfully invoke 5 agents in parallel without using an orchestrator.

## The Critical Pattern
**All agents MUST be invoked in a single message using multiple `<invoke>` blocks within one `<function_calls>` wrapper.**

## Exact XML Structure Used

```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Research Swiss cheese</parameter>
<parameter name="prompt">Research authoritative sources about Swiss cheese including its history, production methods, types (Emmental, Gruyère, etc.), nutritional benefits, and cultural significance. Focus on finding 5-7 high-quality sources with specific facts and statistics about Swiss cheese production and consumption.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Write Swiss cheese content</parameter>
<parameter name="prompt">Write a 100-word informative paragraph about Swiss cheese that covers its origins, characteristics (like the famous holes), major varieties, and cultural importance. Use an engaging, educational tone suitable for a general audience. Include interesting facts that make the content memorable.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">fact-verifier</parameter>
<parameter name="description">Verify cheese facts</parameter>
<parameter name="prompt">Verify these key claims about Swiss cheese: 1) The holes (eyes) in Swiss cheese are caused by bacteria releasing CO2, 2) Switzerland produces over 190,000 tons of cheese annually, 3) Emmental and Gruyère are protected designations, 4) Swiss cheese aging typically ranges from 2-12 months, 5) The tradition dates back to the 12th century. Find authoritative sources to confirm or correct these facts.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">keyword-researcher</parameter>
<parameter name="description">Find cheese keywords</parameter>
<parameter name="prompt">Identify high-value SEO keywords and search terms related to Swiss cheese for content optimization. Include both informational keywords (what is Swiss cheese, how is it made) and commercial keywords (best Swiss cheese brands, where to buy). Also identify long-tail keywords that could drive targeted traffic.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-french-translator</parameter>
<parameter name="description">Swiss cultural perspective</parameter>
<parameter name="prompt">Provide a 100-word paragraph about Swiss cheese from an authentic Swiss cultural perspective, emphasizing its importance in Swiss cuisine, traditions, and economy. Write it in English but include any relevant Swiss French terms or expressions that would add authenticity. Focus on how the Swiss view and consume their cheese differently from how it's perceived internationally.</parameter>
</invoke>
</function_calls>
```

## Key Requirements for Each Agent Invocation

### Required Parameters
Each `<invoke>` block must contain exactly these three parameters:

1. **subagent_type**: The exact name of the agent from your agents directory
2. **description**: Short 2-4 word description of the task
3. **prompt**: Detailed instructions for what the agent should do

### Parameter Structure
```xml
<invoke name="Task">
<parameter name="subagent_type">[agent-name]</parameter>
<parameter name="description">[short description]</parameter>
<parameter name="prompt">[detailed prompt with specific instructions]</parameter>
</invoke>
```

## How This Works

### Parallel Execution Mechanism
1. Claude Code receives all `<invoke>` blocks simultaneously
2. Each agent launches in its own context window
3. All agents execute in parallel (not sequentially)
4. Results return together when all agents complete

### Benefits of This Approach
- **Speed**: All agents run simultaneously, reducing total execution time
- **Independence**: Each agent operates without affecting others
- **Diversity**: Multiple perspectives on the same topic
- **No orchestration overhead**: Direct agent invocation without intermediary

## Example Results Structure

When executed, you'll receive all results together:

```xml
<function_results>
<result>
<name>Task</name>
<output>[Agent 1 output]</output>
</result>
<result>
<name>Task</name>
<output>[Agent 2 output]</output>
</result>
<result>
<name>Task</name>
<output>[Agent 3 output]</output>
</result>
<result>
<name>Task</name>
<output>[Agent 4 output]</output>
</result>
<result>
<name>Task</name>
<output>[Agent 5 output]</output>
</result>
</function_results>
```

## Important Notes

### What Makes This Work
1. **Single Message**: All invocations must be in ONE message
2. **Task Tool**: Must use the "Task" tool (not direct agent calls)
3. **Independent Tasks**: Agents cannot depend on each other's output
4. **Clear Prompts**: Each agent needs complete, self-contained instructions

### Common Pitfalls to Avoid
- ❌ Don't invoke agents in separate messages (they won't run in parallel)
- ❌ Don't create dependencies between agents
- ❌ Don't use orchestrator agents when you want direct parallel execution
- ❌ Don't forget to specify all three parameters for each agent

## Replication Guide

To replicate this parallel execution pattern:

1. **Select Your Agents**
   - Choose 2-10 agents with independent tasks
   - Ensure each can work without others' output

2. **Structure Your Invocation**
   ```xml
   <function_calls>
   <!-- Agent 1 -->
   <invoke name="Task">
   <parameter name="subagent_type">agent-1-name</parameter>
   <parameter name="description">Short task desc</parameter>
   <parameter name="prompt">Detailed instructions...</parameter>
   </invoke>

   <!-- Agent 2 -->
   <invoke name="Task">
   <parameter name="subagent_type">agent-2-name</parameter>
   <parameter name="description">Short task desc</parameter>
   <parameter name="prompt">Detailed instructions...</parameter>
   </invoke>

   <!-- Add more agents as needed -->
   </function_calls>
   ```

3. **Execute in Single Message**
   - Send all invocations together
   - Wait for all results to return
   - Process outputs as needed

## Use Cases for Parallel Agent Execution

### Good Candidates
- Multi-perspective content creation
- Parallel research on different aspects
- Simultaneous fact-checking and writing
- SEO optimization while creating content
- Translation alongside content creation

### Poor Candidates
- Sequential workflows (A needs B's output)
- Complex multi-step processes
- Tasks requiring coordination
- Iterative refinement processes

## Performance Metrics

Based on the Swiss cheese example:
- **Agents invoked**: 5
- **Execution mode**: Parallel
- **Time saved**: ~60-70% vs sequential execution
- **Output diversity**: 5 unique perspectives
- **Content generated**: Research, paragraph, facts, keywords, cultural perspective

## Conclusion

This specification demonstrates the exact pattern for parallel agent execution in Claude Code. The key is using multiple `<invoke>` blocks within a single `<function_calls>` wrapper, with each agent receiving clear, independent instructions. This approach maximizes efficiency while maintaining output quality through specialized agent capabilities.