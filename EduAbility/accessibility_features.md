# Accessibility Features

## Deaf-Mute
| Feature | What It Does | Why It Helps |
| :--- | :--- | :--- |
| Fingerspell companion | "Fingerspell" button on each AI response expands a horizontal letter-by-letter card carousel with hand icons | Reinforces ISL fingerspelling literacy — deaf-mute students learn to associate letters with sign hand shapes while reading AI responses |
| Visual Mode banner | Blue banner: "Visual Mode Active — Tap Fingerspell on responses" | Clear visual instruction (no audio cue needed) so the user knows the feature exists |
| Blue-tinted bubbles | Assistant messages have soft blue background with blue border | Visual differentiation without relying on sound-based notification cues |
| No AI prompt change | AI behavior unchanged | App already has TTS + speech input; deaf-mute users primarily need visual aids, not different AI language |

## Autistic
| Feature | What It Does | Why It Helps |
| :--- | :--- | :--- |
| Visual learning routine | 3-step progress bar (Read → Ask → Quiz) with circles, icons, and connecting lines that highlight as user progresses | Autistic individuals thrive on predictable routines — knowing "what comes next" reduces anxiety and provides structure |
| Structured AI responses | AI uses numbered steps, avoids idioms/sarcasm/metaphors/emojis, starts with one-line summary | Literal, consistent language prevents confusion from figurative speech — a core communication challenge in autism |
| Calming UI theme | Soft teal bubbles, teal borders, squared corners (8px), extra vertical spacing between messages | Reduced visual stimulation — predictable, consistent layout with muted colors prevents sensory overload |
| "Calm Mode" banner | Teal banner with spa icon: "Calm Mode Active — Structured responses enabled" | Reassurance that the environment is adapted — reduces uncertainty |

## ADHD
| Feature | What It Does | Why It Helps |
| :--- | :--- | :--- |
| Pomodoro focus timer | 5-min countdown with play/pause/reset in the banner; session counter (S1, S2...) | ADHD brains struggle with sustained attention — short timed bursts with breaks (Pomodoro technique) are clinically proven to improve focus |
| Refocus buzz | Gentle double-tap phone vibration every 60 seconds while timer is running (toggleable) | Tactile anchor — when attention drifts (which it will), the buzz is a non-intrusive physical reminder to return focus to the task |
| Session complete buzz | Strong vibration pattern when 5-min session ends + "Take a break!" snackbar | Signals transition clearly — ADHD users often miss subtle cues; the physical buzz ensures they notice the break |
| Streak counter | "3 Qs asked!" badge in banner | Gamification/dopamine — ADHD brains respond strongly to immediate rewards; seeing the count go up provides micro-motivation |
| "FOCUS" badge | Purple badge on each AI response bubble | Visual anchor that reinforces the focus mindset on every message |
| Concise AI responses | AI keeps responses under 100 words, uses bullet points, bold key takeaways, ends with micro-challenge | Long text causes ADHD users to lose track mid-paragraph — bullet points and bold keys allow scanning; micro-challenges maintain engagement |
| Purple focus theme | Light purple bubbles with purple borders | Distinct visual identity signals "you're in focus mode" — environmental cue for task mode |

## Dyslexia
| Feature | What It Does | Why It Helps |
| :--- | :--- | :--- |
| Enhanced typography | letterSpacing: 1.5, wordSpacing: 4.0, lineHeight: 2.0, font size +2 | Dyslexic readers confuse letters that are too close — increased spacing prevents letters from visually merging (b/d, p/q confusion) |
| Warm cream bubbles | #FFF8E1 background instead of white | White backgrounds cause visual stress (Irlen syndrome is common with dyslexia) — cream/warm tones reduce glare and improve reading comfort |
| Reading ruler | Toggleable orange horizontal overlay bar that can be dragged up/down over the chat | Dyslexic readers often lose their place between lines — the ruler isolates the current line, mimicking the physical ruler technique used in classrooms |
| Per-bubble "Read Aloud" | Speaker button on each AI message that reads just that bubble via TTS | Multi-sensory learning — hearing while reading reinforces comprehension; users can replay any specific response without scrolling through all messages |
| "Dyslexia-Friendly Mode" banner | Orange banner with ruler toggle button | Quick access to the ruler tool without navigating settings |

---

# Judge Demo Scripts

Use the **same question** for all 4 categories to make the differences obvious: **"Explain photosynthesis"**

> **Opening line to judges:** "We'll now show how the same offline AI tutor adapts its responses, UI, and assistive tools for 4 different disability profiles. Watch how everything changes — not just colors, but the actual AI behavior and support tools."

---

## Demo 1: ADHD

### Setup
- Select **ADHD** from the disability dropdown in the toolbar
- Point out: purple banner appears with Pomodoro timer, streak counter, and Focus label

### Step-by-Step

**Step 1 — Start the Pomodoro Timer**
- Tap **Play** on the 5-min focus timer in the purple banner
- **Say to judges:** "ADHD students struggle with sustained attention. This Pomodoro timer breaks study into 5-minute focused bursts — a clinically proven technique. The session counter tracks progress across sessions."

**Step 2 — Send the question**
- Type: `Explain photosynthesis`
- **Point out the AI response:**
  - Under 100 words (no wall of text — ADHD students lose focus mid-paragraph)
  - **Bold key takeaway** at the very top
  - Bullet points for scanning instead of reading
  - Ends with a **micro-challenge** (e.g., "Can you name the 2 things plants need?")
  - Purple **"FOCUS"** badge on the response bubble

**Step 3 — Ask a follow-up to show streak**
- Type: `What is chlorophyll?`
- **Point out:** Streak counter in banner updates — "2 Qs asked!" — this is gamification that gives ADHD brains the dopamine hit of immediate reward

**Step 4 — Demonstrate the Refocus Buzz**
- **Say:** "Every 60 seconds, the phone gives a gentle double-tap vibration — a tactile anchor to pull attention back when it drifts. Students can toggle this on/off."
- Let judges **hold the phone** to feel the vibration

**Step 5 — Timer completion (explain if time is short)**
- **Say:** "When the 5-minute session ends, a strong vibration pattern fires plus a 'Take a break!' message. ADHD users miss subtle cues, so we make the transition physical and unmissable."

### Key Talking Points
- Pomodoro technique is clinically validated for ADHD focus management
- Micro-challenges keep engagement — ADHD brains need constant novelty
- The AI itself changes behavior (concise + bullet points) — not just the UI skin
- Refocus buzz is a real occupational therapy technique (tactile grounding)

---

## Demo 2: Autistic

### Setup
- Switch to **Autistic** from the disability dropdown
- Point out: teal "Calm Mode Active — Structured responses enabled" banner with spa icon
- Point out: 3-step **progress bar** appears (Read → Ask → Quiz) with circles, icons, and connecting lines

### Step-by-Step

**Step 1 — Show the routine tracker**
- **Say to judges:** "Autistic students thrive on predictable routines. This progress bar shows exactly what comes next — Read material, Ask questions, then Quiz. It reduces anxiety by eliminating uncertainty."
- The "Read" step circle is highlighted (current step)

**Step 2 — Upload a material (optional, to advance Read step)**
- Upload a PDF/TXT file to show the "Read" step completing
- Or skip to Step 3 — the step auto-advances when you ask a question

**Step 3 — Send the question**
- Type: `Explain photosynthesis`
- **Point out the AI response vs ADHD:**
  - **Numbered steps** (1, 2, 3...) — not bullets, because autistic users prefer strict ordering
  - **No idioms, no sarcasm, no metaphors, no emojis** — literal language only
  - Starts with a **one-line summary** before the detailed steps
  - Consistent format every single time — predictability is key
- **Point out the UI:**
  - Soft **teal** bubbles with teal borders (calming, not stimulating)
  - **Squared corners** (8px radius vs 16px for others) — more structured, less playful
  - **Extra vertical spacing** between messages — less visual clutter

**Step 4 — Ask a follow-up to advance progress bar**
- Type: `What is chlorophyll?`
- **Point out:** The "Ask" step in the progress bar now lights up and the connecting line fills in
- The progress is visible and reassuring

**Step 5 — Use the Quiz quick action**
- Tap the **"Quiz me"** chip at the bottom
- **Point out:** The "Quiz" step highlights — the student can see they've completed the full routine
- **Say:** "The student now has closure — they completed Read, Ask, Quiz. This structured loop is how autistic learners build confidence."

### Key Talking Points
- Figurative language is a clinically documented challenge in autism — our AI avoids it entirely
- The routine tracker mirrors Applied Behavior Analysis (ABA) visual schedules used in therapy
- Calm teal color palette is based on sensory processing research — avoids overstimulation
- Every response has the same predictable format — no surprises

---

## Demo 3: Dyslexia

### Setup
- Switch to **Dyslexia** from the disability dropdown
- Point out: orange "Dyslexia-Friendly Mode" banner with a **ruler toggle** button

### Step-by-Step

**Step 1 — Point out the typography changes immediately**
- **Say to judges:** "Notice the text just changed. Look at the spacing."
- **Point out:**
  - **Letter spacing** increased (1.5) — letters don't visually merge (prevents b/d, p/q confusion)
  - **Word spacing** increased (4.0) — words are clearly separated
  - **Line height** doubled (2.0) — lines don't blur into each other
  - **Font size** is +2 larger
  - **Warm cream background** (#FFF8E1) instead of white — reduces visual stress (Irlen syndrome)

**Step 2 — Send the question**
- Type: `Explain photosynthesis`
- **Point out the response:**
  - Same AI behavior as default (no prompt change needed) — dyslexia is a reading difficulty, not a comprehension one
  - But the **display** is completely transformed — wide spacing, cream bubbles, large text
  - Each response bubble has a **"Read Aloud"** button (speaker icon)

**Step 3 — Tap "Read Aloud" on the response**
- Tap the orange **Read Aloud** button on the AI response
- The phone reads that specific bubble via TTS
- **Say:** "Multi-sensory learning — hearing while reading reinforces comprehension. They can replay any specific response, not just hear everything at once."

**Step 4 — Toggle the Reading Ruler**
- Tap the **ruler toggle** in the orange banner
- An orange horizontal overlay bar appears on the chat
- **Drag it up and down** to demonstrate
- **Say:** "This is a digital reading ruler — dyslexic readers often lose their place between lines. This isolates the current line, exactly like the physical ruler technique used in classrooms. The student can drag it to wherever they're reading."

**Step 5 — Compare with normal mode (quick toggle)**
- Briefly switch disability to "None" to show default text
- Switch back to Dyslexia
- **Say:** "See the difference? The same text is now physically easier to read. This isn't cosmetic — it's based on British Dyslexia Association typography guidelines."

### Key Talking Points
- Typography changes are based on British Dyslexia Association and Dyslexia Style Guide research
- Cream/warm backgrounds address Irlen Syndrome (visual stress) — common comorbidity with dyslexia
- Reading ruler mimics a real classroom intervention tool — now digital
- Per-bubble TTS gives control — student chooses what to hear, not forced to listen to everything
- AI response content doesn't change — dyslexia affects reading, not understanding

---

## Demo 4: Deaf-Mute

### Setup
- Switch to **Deaf-Mute** from the disability dropdown
- Point out: blue "Visual Mode Active — Tap Fingerspell on responses" banner

### Step-by-Step

**Step 1 — Send the question**
- Type: `Explain photosynthesis`
- **Point out the UI:**
  - Soft **blue** bubbles with blue border on assistant messages
  - Clean visual differentiation — no reliance on sound-based notification cues

**Step 2 — Tap "Fingerspell" on the response**
- Tap the blue **Fingerspell** button on the AI response bubble
- A horizontal **letter-by-letter card carousel** expands below the text
- Each card shows: the letter (large, bold) + a hand icon below it
- **Say:** "This teaches ISL (Indian Sign Language) fingerspelling. The student reads the AI response and can simultaneously learn how to spell key words using hand shapes. Each letter maps to a sign."

**Step 3 — Scroll through the fingerspell cards**
- Swipe horizontally through the letter cards
- **Point out:** Spaces between words create visible gaps in the carousel — word boundaries are preserved
- Tap "Hide Signs" to collapse, then "Fingerspell" again to re-expand

**Step 4 — Show that AI response is unchanged**
- **Say:** "Notice the AI response itself is the same as default mode — no prompt modification. Deaf-mute students don't need simplified language, they need visual communication tools. The app already has TTS and speech input; this profile adds sign language literacy on top."

**Step 5 — Demonstrate speech-to-text input**
- Tap the **microphone** button and speak a question
- **Say:** "Deaf-mute students who can read but not speak can type. Those who have partial hearing can also use speech input. The app supports both interaction modes."

### Key Talking Points
- Fingerspelling is foundational in ISL education — linking text to signs builds literacy
- The AI doesn't change its language — deaf-mute is a communication modality difference, not a comprehension one
- Blue theme provides a calm, visually distinct mode without sound dependency
- The app supports both text input and speech input — inclusive of varying deaf-mute abilities

---

## Side-by-Side Comparison (Quick Reference for Judges)

| Aspect | ADHD | Autistic | Dyslexia | Deaf-Mute |
| :--- | :--- | :--- | :--- | :--- |
| **Theme Color** | Purple | Teal | Orange/Cream | Blue |
| **AI Prompt Modified?** | Yes — concise, bullets, bold, micro-challenge | Yes — numbered steps, no idioms, literal language | No | No |
| **Unique UI Tool** | Pomodoro timer + Refocus buzz | 3-step progress bar (Read→Ask→Quiz) | Reading ruler + Per-bubble TTS | Fingerspell carousel |
| **Banner** | "Focus" + timer + streak count | "Calm Mode Active" + spa icon | "Dyslexia-Friendly Mode" + ruler toggle | "Visual Mode Active" |
| **Bubble Style** | Purple border, FOCUS badge | Teal border, squared corners (8px), extra spacing | Cream background, wide letter/word/line spacing | Blue border |
| **Vibration/Haptics** | Refocus buzz (60s), session complete buzz | None | None | None |
| **Gamification** | Streak counter ("3 Qs asked!") | Routine completion progress | None | None |
| **Clinical Basis** | Pomodoro technique, tactile grounding | ABA visual schedules, literal language processing | BDA typography guidelines, Irlen Syndrome research | ISL fingerspelling pedagogy |

---

## Killer Closing Line

> "Every feature maps to real clinical research — Pomodoro for ADHD, literal language for Autism, increased spacing for Dyslexia, fingerspelling for Deaf-Mute. We didn't just make it accessible — we made it **therapeutically informed**."
