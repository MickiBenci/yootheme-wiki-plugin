---
title: "YOOforged: The Complete Guide to AI in YOOtheme Pro (2026)"
type: source
status: verified
yootheme_version: "5.0.33"
sources: ["raw/The Complete Guide to AI in YOOtheme Pro (2026).md"]
tags: [ai, tooling, third-party, ecosystem]
updated: 2026-07-29
---

Blog post from [yooforged.com](https://yooforged.com/resources/blog/the-complete-guide-to-ai-in-yootheme-pro-2026/),
published 2026-04-01, saved in full at `raw/The Complete Guide to AI in YOOtheme Pro (2026).md`.

## Nature of the source

**This is the first third-party source in the wiki, and it is marketing.** The author is the
founder of YOOforged, an AI toolkit for YOOtheme Pro, writing about their own product — a declared
conflict of interest. The page `status: verified` above means only that this summary faithfully
reports what the source says; **every claim that comes solely from this article is treated as
`inferred`** and is attributed explicitly wherever it is used. Nothing here is official YOOtheme
documentation.

## What it confirms (already `verified` elsewhere)

The article independently restates facts the wiki has already verified against the theme source —
useful as real-world corroboration, not documented again here:

- YOOtheme layouts are JSON node trees with typed elements, props, conditions and dynamic content
  sources → canonical baseline in the `json-schema` skill,
  [[sources/skill-yootheme-json-schema]]
- Column widths are constrained to specific UIkit grid fractions →
  [[issues/column-width-props]], [[uikit/uk-grid]]
- Generic LLMs asked for YOOtheme JSON invent plausible but non-existent element types (the article
  names `hero` and `call_to_action`) and the builder either refuses the import or silently drops
  the unknown elements — a practical confirmation of why the skill's invariants exist

## What is new (all `inferred` from this source)

- **Six modes of AI assistance** the author claims cover ~90% of builder work: layout generation,
  style generation (LESS variables from a description or screenshot), translation of a JSON's text
  nodes, copywriting (tone rewrite of a JSON's text nodes), HTML-to-YOOtheme conversion, and a
  Q&A assistant for YOOtheme/UIkit
- **The YOOforged layout-generation pipeline**: prompt classification → template matching against
  a curated library of hand-built schema-valid JSON templates (~50 section archetypes) →
  schema-constrained generation (element types from a fixed enum, props validated, currently
  Vertex AI Gemini) → layout normalisation (nesting, column-width math, IDs) → validation with
  retry. Distilled as a reference architecture in [[concepts/ai-layout-generation]]
- **Claim: builder JSON is identical on WordPress and Joomla**, so generation is CMS-agnostic.
  Partially corroborated by the theme source — see the verification note in
  [[concepts/ai-layout-generation]]
- **Claim: UIkit 3's strictness makes YOOtheme uniquely well-suited to AI generation** compared to
  builders like Elementor, where the same visual outcome has many non-canonical encodings
- Stated limits (per the author): novel non-archetypal layouts, brand nuance, persuasive copy,
  Joomla dynamic content maturity, hosted-model latency, and whole-site generation all
  underperform today

## What it contradicts

Nothing. No conflict found with the skills, the theme source, or any existing wiki page — no
`issues/` page needed.

## Propagation

- [[concepts/ai-layout-generation]] — created from this source: why generic LLMs fail at YOOtheme
  JSON and which constraints make generation tractable
