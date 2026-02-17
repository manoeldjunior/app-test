---
name: hybrid-builder
description: Merge the aggressive conversion tactics of a Competitor (Layout/UX) with the Brand Identity of Magalu.
---
# Skill: Hybrid Interface Synthesis

## Objective
Merge the aggressive conversion tactics of a Competitor (Layout/UX) with the Brand Identity of Magalu.

## Workflow
1. **Analyze the Competitor Screen:**
   - Identify the "Hero Action" (e.g., Mercado Livre's Green Credit Bar).
   - Measure the whitespace and component density.
   
2. **Apply the Magalu Skin:**
   - **Backgrounds:** Keep white/clean.
   - **Primary Action:** Magalu Blue (#0086FF).
   - **Typography:** Inter/Roboto (Magalu Standard).
   
3. **Inject the Credit Trigger:**
   - IF screen == "Home" OR "PDP":
     - Insert a "Credit Limit" pill component near the price tag.
     - Reference `funnel_logic.md` for the exact trigger behavior.

## Output format
Generate a React Native / Flutter component named `Hybrid_{CompetitorName}_{VariantID}.tsx`.