# Swiss Localization Template

## Overview
Replaces swiss-localization-orchestrator with parallel translation and compliance checking for Swiss market content.

## Swiss Multilingual Content Workflow

### Option 1: Translate Existing Content
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">swiss-german-translator</parameter>
<parameter name="description">Translate to Swiss German</parameter>
<parameter name="prompt">Translate to Schweizerdeutsch for German-speaking Switzerland: [PASTE ENGLISH CONTENT]. Use formal Sie, Swiss spelling conventions, local terminology.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-french-translator</parameter>
<parameter name="description">Translate to Swiss French</parameter>
<parameter name="prompt">Translate to français suisse for Romandie: [PASTE ENGLISH CONTENT]. Use formal vous, Swiss French expressions, regional preferences.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-italian-translator</parameter>
<parameter name="description">Translate to Swiss Italian</parameter>
<parameter name="prompt">Translate to italiano svizzero for Ticino: [PASTE ENGLISH CONTENT]. Use formal Lei, Ticinese variations, regional context.</parameter>
</invoke>
</function_calls>
```

Then verify:
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">swiss-language-verifier</parameter>
<parameter name="description">Verify translations</parameter>
<parameter name="prompt">Verify accuracy of all three Swiss translations. Check for: linguistic correctness, regional appropriateness, consistent terminology across languages.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-compliance-checker</parameter>
<parameter name="description">Check compliance</parameter>
<parameter name="prompt">Ensure Swiss legal and cultural compliance for [CONTENT TYPE]. Check: data protection laws, financial regulations, cultural sensitivities.</parameter>
</invoke>
</function_calls>
```

### Option 2: Create New Swiss Content

First research:
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">source-gatherer</parameter>
<parameter name="description">Swiss context research</parameter>
<parameter name="prompt">Research [TOPIC] in Swiss context. Focus on Swiss regulations, market conditions, cultural perspectives, cantonal differences.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">audience-profiler</parameter>
<parameter name="description">Define Swiss audience</parameter>
<parameter name="prompt">Define Swiss target audience for [TOPIC] by canton/language region. Include demographics, cultural preferences, business customs.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-compliance-checker</parameter>
<parameter name="description">Check regulations</parameter>
<parameter name="prompt">Check Swiss regulatory requirements for [TOPIC]. Include federal laws, cantonal variations, industry-specific compliance.</parameter>
</invoke>
</function_calls>
```

Then create and translate:
```xml
<function_calls>
<invoke name="Task">
<parameter name="subagent_type">body-writer</parameter>
<parameter name="description">Create Swiss content</parameter>
<parameter name="prompt">Create content about [TOPIC] with Swiss perspective. Include Swiss examples, local references, neutral tone.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-german-translator</parameter>
<parameter name="description">Deutschschweiz version</parameter>
<parameter name="prompt">Create Deutschschweiz version of [TOPIC] content. Adapt for Zürich/Bern business culture, use Swiss German conventions.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-french-translator</parameter>
<parameter name="description">Romandie version</parameter>
<parameter name="prompt">Create Romandie version of [TOPIC] content. Adapt for Geneva/Lausanne culture, use Suisse romand expressions.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-italian-translator</parameter>
<parameter name="description">Ticino version</parameter>
<parameter name="prompt">Create Ticino version of [TOPIC] content. Adapt for Italian-speaking Switzerland, use regional variations.</parameter>
</invoke>
<invoke name="Task">
<parameter name="subagent_type">swiss-language-verifier</parameter>
<parameter name="description">Verify all versions</parameter>
<parameter name="prompt">Verify all language versions for accuracy, consistency, and cultural appropriateness across Swiss regions.</parameter>
</invoke>
</function_calls>
```

## Regional Variations

### For German-Speaking Switzerland (63%)
```
Focus on Zürich/Bern business culture:
1. swiss-german-translator: Use Züritüütsch or Berndeutsch variants
2. swiss-compliance-checker: Check Swiss-German business norms
```

### For French-Speaking Switzerland (23%)
```
Focus on Geneva/Lausanne international culture:
1. swiss-french-translator: Use Suisse romand expressions
2. swiss-compliance-checker: Check French-Swiss formalities
```

### For Italian-Speaking Switzerland (8%)
```
Focus on Ticino/Southern Switzerland:
1. swiss-italian-translator: Use Ticinese variations
2. swiss-compliance-checker: Check Italian-Swiss customs
```

## Compliance Considerations

### Financial Content
```
1. swiss-compliance-checker: FINMA regulations
2. fact-verifier: Verify Swiss financial data
3. swiss-language-verifier: Ensure precise terminology
```

### Healthcare Content
```
1. swiss-compliance-checker: Swissmedic requirements
2. swiss-language-verifier: Medical terminology in 3 languages
3. fact-verifier: Swiss healthcare statistics
```

### Legal Content
```
1. swiss-compliance-checker: Swiss federal and cantonal law
2. swiss-language-verifier: Legal terminology precision
3. source-gatherer: Swiss legal precedents
```

## Example: Swiss Financial Services Blog

```
Translate financial blog for Swiss market. Invoke in parallel:

1. swiss-german-translator: Adapt for Zürich financial center
2. swiss-french-translator: Adapt for Geneva private banking
3. swiss-italian-translator: Adapt for Lugano market
4. swiss-compliance-checker: Verify FINMA compliance
5. swiss-language-verifier: Ensure terminology accuracy
```

## Cultural Adaptation Tips
- Maintain Swiss neutrality in tone
- Respect cantonal differences
- Use formal address (Sie/Vous/Lei)
- Include all official languages when possible
- Reference Swiss examples and case studies