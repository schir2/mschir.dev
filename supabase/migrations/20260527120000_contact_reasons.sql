-- contact_reasons lookup table
create table public.contact_reasons
(
    id     uuid primary key      default gen_random_uuid(),
    label  varchar(100) not null,
    "order" smallint    not null default 1,
    constraint unique_contact_reason_label unique (label)
);

create index idx_contact_reasons_order on public.contact_reasons ("order");

insert into public.contact_reasons (label, "order") values
    ('Employer Inquiry', 1),
    ('Contracting',      2),
    ('Article Question', 3);

alter table public.contact_reasons enable row level security;

create policy "contact_reasons_public_read"
    on public.contact_reasons
    for select
    to public
    using (true);

-- Migrate contact_messages: replace free-text subject with FK
alter table public.contact_messages drop column if exists subject;
alter table public.contact_messages
    add column reason_id uuid references public.contact_reasons (id) on delete set null;