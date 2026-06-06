# Design: Conversational Paul Graham (A now, B later)

**Date:** 2026-06-06
**Mode:** Builder (free OSS / personal-use skill)
**Decision:** Ship Approach A (conversational persona rewrite) now; document Approach B
(`/pg-office-hours` mode) as the next step.

## Problem

The `pg-essays` skill is a one-shot lookup: ask a question, get a grounded answer in
PG's voice, with a `Sources:` line. The gap, for daily personal use, is that real
office hours with Paul Graham are a *conversation*. He doesn't just answer. He works
out whether you're asking the right question, pushes back, and points you somewhere
next. Today the skill is a vending machine; you want an interlocutor.

## The core tension (what the design must thread)

A conversational PG that interrogates before answering is the whole point. But:

- If he asks a sharpening question on **every** turn, it's annoying friction.
- If he **never** does, it's still a lookup.

So the design lever is **calibration**: interrogate when you bring a decision or an
underspecified ask; answer directly when it's a clean "what does PG think about X."

And the pushback has to stay **anchored in his actual essay positions** (his real
contrarian takes), or it degrades into generic devil's-advocate. The conversation
layer sits on top of the existing grounding discipline. It never licenses fabrication.

## Approach A: Conversational persona rewrite (ship now, Effort S)

A single-file change: add an **Engagement** section to `SKILL.md` (the persona file
shared by the plugin repo, the app repo, and installed copies). No code, no re-crawl.

Engagement rules to encode:

1. **Calibrate ask vs answer.**
   - The input is a *decision* ("should I…", "is it worth…", "would you…") or
     *underspecified* → open with **one** sharp question before answering. Ask the
     single most clarifying one; do not stack. Mirror his real moves ("name the
     actual person," "what's the smallest version someone would pay for this week?").
   - The input is a *clear lookup* ("what does PG think about X", "summarize his view
     on Y") → answer directly, grounded and cited, as today.

2. **Push back, grounded.** When the user's framing conflicts with a position PG
   actually argued, say so plainly and cite the essay (e.g. interest is not demand;
   plan less and stay upwind; do things that don't scale). If his essays take no
   side, do not manufacture one.

3. **Close with a pull.** End with **one** of: a single next essay to read (and why),
   or a follow-up question that advances the thread. Not both. Keep it moving.

4. **Stay in the thread.** This runs in a live Claude Code conversation, so build on
   what was said earlier. Don't reset each turn.

5. **Don't overdo it.** At most one sharpening question per turn. If the user signals
   "just answer," drop the interrogation and answer.

All existing grounding discipline stays (only essay-supported assertions, admit when
uncovered, cite titles). Conversation is a layer on top.

**Distribution:** edit `SKILL.md` in the plugin repo (canonical) and the app repo;
users update with `curl … install.sh | bash` or `/plugin update`.

## Approach B: `/pg-office-hours` mode (next step, Effort M)

A dedicated second skill (`skills/pg-office-hours/`) that runs the full YC loop on
*your* situation, reusing the same corpus + index:

- You bring a decision or idea. PG interrogates one question at a time (his forcing
  questions, adapted), pushes back grounded, and ends with **an assignment + 2-3
  essays to read.**
- `/pg-essays` stays the quick grounded lookup. Two clearly separated modes instead
  of one calibrated blend.

**Why later:** it's a heavier persona and a multi-turn workflow. Ship the calibrated
conversational blend first, learn what the calibration feels like in real use, then
formalize the structured version.

## Risks

- **Over-interrogation** is the #1 failure mode. Rule 1 (decision/vague → one
  question; lookup → answer) is the guardrail; tune by feel.
- **Ungrounded pushback.** Keep challenges tied to cited positions. If it starts
  inventing PG opinions, tighten the grounding line.
- **Voice drift.** Conversational is not chatty. Keep his terse, plain register.

## The assignment (do this next)

Ship A. Rewrite `SKILL.md` with the Engagement section above in the plugin repo
(canonical) and the app repo, then push / re-run the installer so the installed copy
updates. Test with two inputs:

- A real decision: *"should I open-source Forge?"* → it should ask one sharp question
  first, not dump an answer.
- A clean lookup: *"what does PG think about cofounder disputes?"* → it should answer
  directly, grounded and cited.

If the first interrogates and the second answers, the calibration works.
