begin;

select plan(9);

select has_table(
  'public', 'featured_projects',
  'featured_projects table exists'
);

select has_column(
  'public', 'featured_projects', 'id',
  'featured_projects has id column'
);

select has_column(
  'public', 'featured_projects', 'project_id',
  'featured_projects has project_id column'
);

select col_not_null(
  'public', 'featured_projects', 'project_id',
  'project_id is not null'
);

select col_is_unique(
  'public', 'featured_projects', 'project_id',
  'project_id has unique constraint'
);

select has_column(
  'public', 'featured_projects', 'tagline',
  'featured_projects has tagline column'
);

select col_not_null(
  'public', 'featured_projects', 'tagline',
  'tagline is not null'
);

select has_column(
  'public', 'featured_projects', 'display_order',
  'featured_projects has display_order column'
);

select col_not_null(
  'public', 'featured_projects', 'display_order',
  'display_order is not null'
);

select * from finish();

rollback;
