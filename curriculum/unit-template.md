# Unit Template

> This is the canonical format every unit in `units/` follows. Each unit folder contains three files: `lesson-plan.md`, `lab.md`, and `assessment.md`. Copy these skeletons when creating or revising a unit.

---

## `lesson-plan.md` skeleton

```markdown
# Unit NN — <Title>

- **Module:** <module number & name>
- **Suggested week:** <week #>
- **Estimated time:** <# of ~50-min class periods>
- **PEN-200 mapping:** <which PEN-200 topic(s) this adapts>

## Learning objectives
By the end of this unit, students can:
- <objective 1 — measurable, verb-first>
- <objective 2>
- ...

## Standards alignment
- NICE Framework: <work roles / tasks>
- CSTA / state CS standards: <codes>
- Security+ domain(s): <if applicable>

## Key vocabulary
| Term | Student-friendly definition |
|------|------------------------------|
| ... | ... |

## Materials & prep
- <platform accounts, VMs, handouts, slides>
- Instructor prep notes: <what to set up beforehand>

## ⚖️ Ethics & legal callout
<The specific ethical/legal point to reinforce this unit, and a discussion prompt.>

## Lesson sequence

### Day 1 — <focus>
- **Warm-up (5–10 min):** ...
- **Direct instruction (15–20 min):** ...
- **Guided practice (15 min):** ...
- **Independent practice / lab:** ...
- **Closure / exit ticket (5 min):** ...

### Day 2 — <focus>
...

## Differentiation
- **Support:** ...
- **Extension:** ...

## Homework / independent work
- ...

## Assessment
- Formative: <exit tickets, checks>
- Summative: see `assessment.md`

## Instructor notes & common pitfalls
- ...
```

---

## `lab.md` skeleton

```markdown
# Unit NN Lab — <Title>

- **Platform:** <TryHackMe room / HTB Academy module / VirtualBox VM / picoCTF / OverTheWire>
- **Time:** <minutes>
- **Difficulty:** <intro / beginner / intermediate>

## 🔒 Safety & authorization reminder
You may only run these techniques inside this lab environment. Doing this to any
system you do not own or have written permission to test is illegal.

## Objectives
- ...

## Setup
1. ...

## Walkthrough
### Step 1 — ...
<commands, screenshots-to-take, expected output>

### Step 2 — ...

## Deliverables
- <what students submit: lab journal entries, flags, screenshots, short writeup>

## Stretch goals (optional)
- ...

## Answer key (instructor only)
- ...
```

---

## `assessment.md` skeleton

```markdown
# Unit NN Assessment — <Title>

## Formative checks
- ...

## Quiz
1. <question> 
   - A) ... B) ... C) ... D) ...
... (include an **Answer key** section at the bottom)

## Project / performance task (if applicable)
**Prompt:** ...
**Deliverable:** ...
**Rubric:**
| Criteria | Exemplary (4) | Proficient (3) | Developing (2) | Beginning (1) |
|----------|---------------|----------------|----------------|---------------|
| ... | | | | |

## Answer key
...
```

## Style conventions
- Write for a 9th–12th grade reading level; define jargon on first use.
- Every lab restates the safety/authorization reminder.
- Prefer free tools and platforms; note any cost.
- Commands shown in fenced code blocks; expected output described.
- Keep an ethics thread visible in every unit.
