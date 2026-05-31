begin;

select plan(3);

select has_column(
  'public', 'skills', 'is_highlighted',
  'skills has is_highlighted column'
);

select col_not_null(
  'public', 'skills', 'is_highlighted',
  'is_highlighted is not null'
);

select col_type_is(
  'public', 'skills', 'is_highlighted', 'boolean',
  'is_highlighted is boolean'
);

select * from finish();

rollback;
