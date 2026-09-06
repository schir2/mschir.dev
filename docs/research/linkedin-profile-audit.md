# LinkedIn Profile Audit

Snapshot taken directly from https://www.linkedin.com/in/marek-schir-95229684/ (main profile, Experience, Skills, Certifications sub-pages) for the purpose of improving recruiter/search visibility. Not tied to any code in this repo.

## What's already working

- Professional photo and banner image are set, and the profile carries a verified badge.
- Clear title progression at one employer: Software Developer (part-time) → Programming Analyst → IT Manager → Director of IT — this tells a real growth story if the surrounding content backs it up.
- Skills section is populated with specific, real technologies (Python, Django, C#, TypeScript, SQL Server, MySQL, GitHub, Linux, etc.) rather than vague buzzwords.
- Two real certifications listed (CCNA, and the Cisco Specialist cert on the CCNP Enterprise track), plus several Coursera credentials in ML/data science.
- Education is listed (CUNY New York City College of Technology).
- "Open to Work" is already enabled (currently scoped to recruiters only).

## Highest-leverage gaps

Ranked by expected impact on visibility/recruiter search, highest first.

### 1. No About/Summary section
LinkedIn's own UI flags this on your profile: "Members who include a summary receive up to 3.9 times as many profile views." This is currently empty. This is the single highest-leverage fix available — a 3-4 paragraph summary naming your core stack (Python/Django, Vue/Nuxt, IT infrastructure, and increasingly AI/agent engineering) is both a search-keyword surface and the first thing a human reader looks for.

### 2. No experience descriptions on any role
All four roles (Director of IT, IT Manager, Programming Analyst, Software Developer) show only a skill-tag list ("Skills: C#, Django, +18 skills") with zero bullet points describing scope, responsibilities, or achievements. This hurts you twice: recruiters skimming can't see impact, and LinkedIn's search ranking weighs description text, not just tagged skills. Each role should get 3-6 bullets — concrete outcomes, not just tool names (e.g. "led migration of X system," "built Y platform serving Z users," "reduced [cost/time] by managing…").

### 3. Skills list doesn't reflect current or full scope of work
The listed skills are almost entirely the older web-dev/backend stack. Missing entirely:
- Anything AI/agent-related (Claude, LLM API integration, prompt engineering, Dograh, agent tool implementation) — despite this being live, current work
- Integration platforms (HubSpot, Stripe, Zapier, n8n)
- Networking/Active Directory — surprising given you hold CCNA/CCNP-track certifications but list zero networking skills
- Any soft skills (communication, stakeholder management, training/enablement)

Cross-reference `docs/research/resume-skills.md` in this repo — it's a more complete and current inventory than what's on LinkedIn today.

### 4. Headline is a wasted opportunity
Current headline is just "IT Director at M&M Environmental." The headline is the most heavily-weighted, most visible piece of text on LinkedIn — it appears in every search result, comment, and connection request, not just your profile page. A generic title-only headline gives recruiters and search nothing to match on. Consider something keyword-dense reflecting the actual breadth: e.g. "IT Director | Full-Stack Developer (Python/Django, Vue/Nuxt) | AI & Agent Engineering | Network Infrastructure (CCNA/CCNP)."

### 5. Default (non-vanity) profile URL
URL is still `linkedin.com/in/marek-schir-95229684` — the auto-generated numeric-suffixed default, not claimed as a clean vanity URL (e.g. `linkedin.com/in/marekschir`). Free, one-time fix under Settings → Edit public profile & URL; looks more deliberate on a resume or business card.

### 6. Low activity and network signals
30 connections, 31 followers, 0 posts, 2 search appearances in the last 7 days. LinkedIn's search ranking and recruiter-surfacing both reward an active, larger network. This doesn't need to mean regular posting — even connecting with past colleagues and a handful of relevant industry follows would move the needle.

### 7. No Featured section
There's a "Featured" section option (pinned posts, articles, links, media) that isn't in use. This is a natural place to link your portfolio site (mschir.dev) and specific project write-ups — free, high-signal proof of work that a skills list or job title can't convey on its own.

### 8. CCNP inconsistency between Skills and Certifications
"CCNP Certified" appears as a self-added *skill* tag, but the actual Licenses & Certifications section only lists "Cisco Certified Specialist — Enterprise Advanced Infrastructure Implementation" (which is part of the CCNP Enterprise track, not the same named credential). Worth reconciling one way or the other — either add the formal CCNP certification entry if it was actually earned, or adjust the skill tag so the two sections agree. An inconsistency like this is exactly the kind of thing a recruiter fact-checking a resume against LinkedIn would notice.

### 9. Sparse endorsements
Most listed skills have 0-1 endorsements. Not critical, but low endorsement counts on an otherwise skill-heavy profile can read as a thin network rather than lack of ability — tied to gap #6 above.

## Suggested order of operations

1. Write the About section (biggest single lever, no dependencies).
2. Add bullet-point descriptions to all four roles.
3. Rewrite the headline.
4. Update the Skills section using `docs/research/resume-skills.md` as the source list.
5. Claim a vanity profile URL.
6. Add a Featured section linking mschir.dev.
7. Resolve the CCNP inconsistency.
8. Grow connections/network over time (ongoing, not a one-time fix).
