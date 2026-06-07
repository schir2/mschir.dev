update public.contact_reasons set label = 'Contract Inquiry' where label = 'Contracting';

insert into public.contact_reasons (label, "order") values
    ('Project Question', 4),
    ('Other',            5);
