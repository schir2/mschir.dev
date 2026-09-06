# Resumes

Three base resumes built from `../research/resume-skills.md`, the LinkedIn profile, and the project write-ups in `supabase/seeds/03_projects.sql`. Format decisions follow `../research/resume-format-research.md`; role targeting follows `../research/target-roles.md`.

| File | Target roles | Format |
|---|---|---|
| `senior-software-engineer-fullstack.md` | Senior Software Engineer, Full-Stack Engineer, Software Engineer (Internal Tools / Business Systems) | Reverse-chronological, skills near the top, projects after experience. Aim for 1.5 pages. |
| `senior-software-engineer-backend.md` | Senior Backend Engineer (Python), Senior Software Engineer at vertical SaaS | Hybrid: three flagship systems first, compressed chronology after. Useful when the posting cares about depth over breadth. |
| `ai-integration-engineer.md` | Forward Deployed Engineer, Applied AI Engineer, Integrations Engineer, Solutions Engineer (Applied AI) | Reverse-chronological with the current role split into "AI and integration" and "platform, delivery, infrastructure" sub-sections. Two pages. This is the strongest fit per the role research. |

## Why They Look the Way They Do

- **Single column, standard section names, plain-text header.** Two-column layouts lose sections in ATS parsers; headers and footers get skipped.
- **Skills block near the top.** None of the four job titles says "engineer," so the skills line has to make the "Python backend engineer" read happen in the recruiter's first pass.
- **Two-sentence summary.** Normally skipped; included because the candidate is senior and the title needs translating. Starts with the target job-title noun.
- **One employer header, four dated title sub-entries, a one-line progression note.** This is the recommended pattern for promotions at one company and the direct counter to single-employer bias.
- **Official title first, clarifier in parentheses.** "Director of IT (Lead Software Engineer)" and "Programming Analyst (Full-Stack Developer)" are clarifications, not promotions. Use the official title alone on application and background-check forms, and use the identical form on LinkedIn.
- **XYZ bullets, past tense, one to two lines, no trailing periods, technologies embedded.** No soft skills in the skills block; stakeholder work, training, and SOPs appear as bullets instead.
- **Projects with live URLs.** Arcus and Calcura are independently verifiable modern work outside the single employer.
- **Education at the bottom, no year.** Standard for experienced candidates.
- **No em dashes, no AI-tell vocabulary.** A fifth of hiring managers in a 2025 survey would reject a resume they read as AI-written.

## Before Sending Any of These

1. **Fill or delete every `[fill: ...]` placeholder.** Nothing in brackets is verified. The strongest additions would be: calls processed per month by the AI pipeline, cost per call before and after prompt tuning, the human-review rate, quotes per month through the portal, and hours per week saved by the n8n/Zapier/cron automations.
2. **Reconcile dates with LinkedIn.** LinkedIn lists IT Manager as 2019-2022, overlapping Director of IT from May 2021. The resumes use 2019-2021. Pick one and make LinkedIn match; background checks verify dates.
3. **Confirm the exact degree name.** LinkedIn says "Bachelor's degree, Computer Engineering." City Tech's program may be a B.Tech in Computer Engineering Technology; use whatever the diploma says.
4. **Confirm the NYCHA platform attribution.** The seed data credits Green Orchard Group's contract with the repo under the MMPC GitHub org. State the relationship the way you would in an interview.
5. **Confirm you are comfortable with the title clarifiers.** The test: would your employer confirm the scope without hesitating?
6. **Dograh.** The bullet is a stub; describe what the voice agent handles and any volume.
7. **Contact line.** Add email and phone. Claim a LinkedIn vanity URL first (see `../research/linkedin-profile-audit.md`) and update the header.
8. **Plain-text test.** Paste the rendered resume into a text file. If the sections scramble, fix the layout before applying anywhere.

## Rendering

```bash
# DOCX (edit further in Word or Google Docs, then export PDF)
pandoc docs/resumes/ai-integration-engineer.md -o ai-integration-engineer.docx

# PDF directly, if a LaTeX engine is installed
pandoc docs/resumes/ai-integration-engineer.md -o ai-integration-engineer.pdf -V geometry:margin=0.5in -V fontsize=10.5pt
```

Keep it single column after export. Calibri or Arial at 10.5-11pt, 0.5in margins. Do not paste into a two-column template. Submit PDF unless the posting asks for DOCX.

## Tailoring

Keep these three as bases. For a posting you care about: mirror its exact nouns in the summary, the skills lines, and two or three bullets; reorder bullets so the most relevant come first; add the full form of any abbreviation the posting uses. Do not keyword-stuff, and do not list anything you cannot discuss for five minutes.

## Gaps Worth Closing Before AI-Role Applications

The role research flagged these as the visible gaps against Applied AI and FDE postings. None are on the resumes because none exist yet; do not add them until they do.

- A retrieval (RAG) project with recall or precision numbers.
- An eval harness with a golden set over the existing call-classification data, so bullets can cite accuracy and regression numbers instead of only the review rate.
- Model Context Protocol (MCP) work. The portfolio MCP server planned in this repo would cover it.
- Kubernetes, Kafka, Terraform: do not list; they are not in the background and the interview would expose it.
