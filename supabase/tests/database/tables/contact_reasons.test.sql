begin;

select plan(5);

select has_table(
  'public', 'contact_reasons',
  'contact_reasons table exists'
);

select has_column(
  'public', 'contact_reasons', 'id',
  'contact_reasons has id column'
);

select has_column(
  'public', 'contact_reasons', 'label',
  'contact_reasons has label column'
);

select col_not_null(
  'public', 'contact_reasons', 'label',
  'label is not null'
);

select col_is_unique(
  'public', 'contact_reasons', 'label',
  'label has unique constraint'
);

select * from finish();

rollback;
