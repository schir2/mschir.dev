# Browser-capable agent

Certain verification tasks require an agent that can make real HTTP requests or drive a browser. These cannot be automated by a standard AFK agent running only CLI tools.

## Known tasks that require a browser agent

### Supabase Storage RLS verification (see issue #3)

After applying storage bucket migrations, the following must be verified:

1. **Public read**: A public HTTP fetch of a file uploaded to the `icons` or `images` bucket succeeds without authentication.
2. **Write RLS**: An unauthenticated `storage.upload` call to either bucket is rejected.

These checks require a running browser session or an HTTP client that can:
- Fetch public storage URLs and assert a 200 response
- Attempt an unauthenticated upload and assert a 403/401 response

A browser-capable agent (e.g. one with Playwright or a fetch-enabled runtime) should be set up to run these checks automatically after any storage migration is applied.

## Status

Not yet implemented. Manual verification is the current fallback — see the agent brief on issue #3 for the exact steps.