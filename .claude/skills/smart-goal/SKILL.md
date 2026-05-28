---
name: smart-goal
description: Guide users through SMART goal setting - transform vague intentions into Specific, Measurable, Achievable, Relevant, and Time-bound goals
disable-model-invocation: true
argument-hint: [rough goal or "interactive"]
---

# SMART Goal Setting Assistant

Help the user create well-formed SMART goals using the framework developed by George T. Doran (1981) and refined through decades of goal-setting research.

## Workflow Selection

Based on $ARGUMENTS:

- If the user passes **"interactive"** or no arguments: Use the **Interactive Q&A** workflow
- If the user passes a **rough goal description**: Use the **Full Analysis** workflow
- If unclear, ask which approach they prefer

---

## Interactive Q&A Workflow

Guide the user step-by-step through each SMART component. Ask one question at a time and wait for their response before proceeding.

### Step 1: Capture the Raw Goal
Ask: "What goal do you want to work on? Just describe it in plain language, even if it's vague."

### Step 2: Specific
Ask these clarifying questions (adapt based on context):
- **What** exactly do you want to accomplish?
- **Why** is this important? What's the motivation?
- **Who** is involved or responsible?
- **Which** resources or constraints are involved?

Help them transform vague language into precise language.

**Weak → Strong example:**
- Weak: "I want to grow my business"
- Strong: "I want to increase day-1 user retention from 0.3% to 5% by redesigning the onboarding flow"

### Step 3: Measurable
Ask:
- **How much/how many?** What quantity or frequency?
- **What's your baseline?** Where are you starting from?
- **What's your target?** What's the end state?
- **How will you track progress?** What metric and method?

Ensure they have both leading indicators (predictive) and lagging indicators (outcome) where appropriate.

### Step 4: Achievable
Ask:
- Do you have the **skills, resources, and capacity** to achieve this?
- Is this **realistic** given your constraints (time, money, team)?
- What **obstacles** might you face?

Help them calibrate to the "stretch zone" - challenging but not impossible:

| Zone | Effect |
|------|--------|
| Comfort Zone (too easy) | Low motivation |
| **Stretch Zone** (challenging but possible) | Peak performance |
| Panic Zone (impossible) | Anxiety, giving up |

### Step 5: Relevant
Ask:
- Does this align with your **larger objectives** (mission, career, values)?
- Is **now the right time** for this goal?
- Is this **worthwhile** relative to opportunity cost?
- Are you the **right person** to pursue this?

This filter prevents "productive busyness" - being efficient at things that don't matter.

### Step 6: Time-bound
Ask:
- **When** is your deadline?
- What **milestones** should exist along the way?
- What's realistic for **30 days? 60 days? 90 days?**

Help them set:
- A hard deadline
- Intermediate milestones (decompose the timeline)
- Weekly or daily process checkpoints

### Step 7: Synthesize
Combine all elements into a final SMART goal statement. Present it in this format:

```
SMART GOAL:
[One clear sentence combining all elements]

BREAKDOWN:
- Specific: [what and why]
- Measurable: [baseline → target, tracking method]
- Achievable: [resources, skills, realistic assessment]
- Relevant: [alignment with larger objectives]
- Time-bound: [deadline and milestones]

ACTION STEPS:
1. [First action with date]
2. [Second action with date]
3. [Third action with date]

REVIEW SCHEDULE: [frequency]
```

---

## Full Analysis Workflow

When the user provides a rough goal, analyze it and produce a complete SMART version.

### Process:
1. **Acknowledge** the rough goal
2. **Identify gaps** - which SMART criteria are missing or weak?
3. **Ask clarifying questions** only for critical missing information
4. **Transform** the goal through each SMART filter
5. **Output** the final SMART goal with the full breakdown format above

### Example Transformation:

**Input:** "I want to figure out if playable ads is a viable business"

**Output:**
```
SMART GOAL:
By April 15, 2026, validate the playable ads pivot by generating 10 sample
playable ads, presenting them to 20 potential mobile game advertising buyers,
and securing at least 3 paid pilot agreements.

BREAKDOWN:
- Specific: Validate whether AI game generation can produce playable ads
  meeting advertiser quality/performance standards
- Measurable: 10 samples created, 20 buyers contacted, 3+ paid pilots closed
- Achievable: Has technical capability, industry contacts, and 8-week runway
- Relevant: Directly addresses core pivot decision; $10B+ market opportunity
- Time-bound: April 15 deadline with milestones on March 1 (samples) and
  March 15 (outreach)

ACTION STEPS:
1. Generate 10 sample playable ads by March 1
2. Complete outreach to 20 potential buyers by March 15
3. Follow up and close pilot agreements by April 15

REVIEW SCHEDULE: Weekly progress check every Friday
```

---

## Key Principles to Apply

### Outcome vs. Output Goals
- **Output** (weaker): "Send 50 cold emails"
- **Outcome** (stronger): "Generate 5 qualified meetings from outreach"

Always push toward outcomes when possible, but pair with process goals the user controls.

### Process Goals
Pair outcome goals with process goals:
- Outcome: "Close $50K in new revenue"
- Process: "Have 5 sales conversations per week"

### Common Mistakes to Help Users Avoid
1. **Too many goals** - suggest focusing on 3-5 major goals max
2. **Too easy** - if 90% confident, probably not ambitious enough
3. **Vanity metrics** - ensure metrics connect to what actually matters
4. **Set and forget** - emphasize the review schedule
5. **Ignoring Relevance** - the most neglected criterion

### The Stretch Zone Check
Ask: "On a scale of 1-10, how confident are you that you can achieve this?"
- 9-10: Probably too easy, push for more ambition
- 6-8: Good stretch zone
- 1-5: May need to scope down or extend timeline

---

## Optional: SMARTER Extension

If appropriate, suggest adding:
- **E - Evaluated:** How will you assess progress and adjust?
- **R - Reviewed:** When will you formally review and potentially revise the goal?

---

## Closing

After finalizing the goal, offer:
1. To help break it into smaller sub-goals
2. To create accountability check-in reminders
3. To run a "pre-mortem" - imagine it's the deadline and you failed, why?
