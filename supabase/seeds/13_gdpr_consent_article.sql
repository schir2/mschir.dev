-- Draft article: What Developers Actually Need to Know About Cookie Consent

insert into public.article_tags (name, slug, icon)
values
    ('Privacy', 'privacy', 'mdi:shield-account'),
    ('GDPR', 'gdpr', 'mdi:gavel')
on conflict (slug) do nothing;

insert into public.articles (id, title, slug, content, summary, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000013',
    'What Developers Actually Need to Know About Cookie Consent',
    'what-developers-need-to-know-about-cookie-consent',
    $article$# What Developers Actually Need to Know About Cookie Consent

Building this site meant I had to stop cargo-culting cookie banners and actually understand
what they require. The regulation is less complicated than it looks, but the details matter
more than most tutorials suggest.

## The Bodies Writing the Rules

There is no single global privacy law. Several jurisdictions have passed their own, and if
your site reaches users in those places, the rules apply regardless of where you are hosted.

**GDPR** covers any site that processes data from EU residents. Enforced by national
authorities in each member state: Ireland's DPC, Germany's BfDI, France's CNIL. The most
broadly applicable framework and the one worth targeting as your baseline.

**UK GDPR** is the post-Brexit version, now maintained by the ICO. For a small site it
mirrors the EU version closely enough to treat as identical.

**CCPA/CPRA** applies to businesses collecting data from California residents. Its focus is
the right to opt out of data sale rather than upfront consent. GDPR is the more demanding
bar, so complying with GDPR covers you here.

**PIPEDA** covers Canadian residents, enforced by the OPC. Similar in intent to GDPR, lighter
in enforcement history.

**LGPD** is Brazil's equivalent. Closest to GDPR in structure.

Building for GDPR compliance covers most of the above by default.

## What Actually Requires Consent

The question is not "does this use cookies?" It is "does this process personal data beyond
what is necessary to deliver the service?"

**No consent needed:**

- Auth sessions and tokens (Supabase auth, JWTs): strictly necessary to keep a user logged in
- Security mechanisms like CSRF tokens and CAPTCHA replacements (Cloudflare Turnstile): needed for the service to function safely
- Preference cookies (color scheme, language selection): functional, not tracking
- Session cookies that expire when the browser closes

**Consent required:**

- **Google Analytics and behavioral analytics tools**: these track user behavior across sessions and often across sites. Under GDPR, no tracking event should fire before explicit consent.
- **Marketing pixels**: Meta Pixel, Google Ads conversions, LinkedIn Insight Tag. These build profiles used for ad targeting.
- **Third-party fonts loaded from external CDNs**: loading Google Fonts from `fonts.googleapis.com` sends the visitor's IP address to Google on every page load. A Munich court fined a site owner €100 in 2022 for exactly this. Self-hosting the fonts eliminates the issue entirely.
- **Third-party embeds**: YouTube iframes, Google Maps, Disqus comment widgets. Each sends data to that third party before the user interacts with it.

The pattern: anything that phones home to a server that can use the data to identify or
profile the user.

## What Non-Compliance Looks Like

GDPR permits fines up to €20 million or 4% of global annual revenue. Those ceilings apply
to serious violations. Documented cases that show the range:

- **€150 million** against Google Ireland (France, CNIL, 2022): making cookie rejection harder than acceptance
- **€1.2 billion** against Meta (Ireland, DPC, 2023): transferring EU user data to the US without adequate safeguards
- **€100** against a German site owner (Munich court, 2022): loading Google Fonts from Google's CDN without consent

The third example is the one relevant to almost every personal or small business site. The
amount was small but the ruling was unambiguous.

Beyond fines, a complaint can trigger an investigation, force a design change, and take
months to resolve.

## The Principles That Actually Matter

**Privacy by default** (GDPR Article 25) means no non-essential processing before consent
is collected. Analytics default to denied until the user accepts, not the other way around.

**Symmetry**: withdrawing consent must be as easy as giving it. A banner with a large
"Accept All" button and a "Manage Preferences" link buried in the footer fails this test.

**Granularity**: consent must be per purpose. Analytics and marketing are separate categories.
A single "I accept cookies" checkbox that covers both is not valid under GDPR.

**No pre-ticked boxes**: consent requires an affirmative action. A pre-checked box is not
consent.

**Records**: under GDPR you must be able to demonstrate that consent was collected. This
means storing a timestamp and the consent state alongside whatever the user accepted.
$article$,
    'A practical breakdown of GDPR, CCPA, and the other privacy regulations developers encounter, covering what actually requires consent, what does not, and what non-compliance looks like in practice.',
    (select id from public.article_categories where slug = 'web-development'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'draft',
    null,
    '2026-06-09 10:00:00+00',
    '2026-06-09 10:00:00+00'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000013', id
from public.article_tags
where slug in ('privacy', 'gdpr', 'security');
