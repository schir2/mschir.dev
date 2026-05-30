-- Allow anonymous visitors to submit the contact form.
create policy "contact_messages_public_insert"
    on public.contact_messages
    for insert
    to public
    with check (true);

-- Only the authenticated site owner can read submissions.
create policy "contact_messages_owner_select"
    on public.contact_messages
    for select
    to authenticated
    using (true);