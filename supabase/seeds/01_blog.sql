insert into public.article_tags (name, slug, icon)
values
-- Programming languages
('Python', 'python', 'logos:python'),
('JavaScript', 'javascript', 'logos:javascript'),
('TypeScript', 'typescript', 'logos:typescript-icon'),
('PHP', 'php', 'logos:php'),
('Scripting', 'scripting', 'mdi:script-text'),

-- Web frameworks & libraries
('Django', 'django', 'logos:django-icon'),
('React', 'react', 'logos:react'),
('Vue.js', 'vue.js', 'logos:vue'),
('Nuxt', 'nuxt', 'simple-icons:nuxtdotjs'),
('Tailwind CSS', 'tailwind-css', 'logos:tailwindcss-icon'),
('HTML', 'html', 'logos:html-5'),
('CSS', 'css', 'logos:css-3'),
('Responsive Design', 'responsive-design', 'mdi:responsive'),

-- Databases & backend
('PostgreSQL', 'postgresql', 'logos:postgresql'),
('Supabase', 'supabase', 'logos:supabase-icon'),
('REST API', 'rest-api', 'mdi:api'),

-- AI & automation
('AI', 'ai', 'mdi:robot'),
('Machine Learning', 'machine-learning', 'mdi:robot'),
('Claude Code', 'claude-code', 'simple-icons:anthropic'),
('N8n', 'n8n', 'simple-icons:n8n'),
('Zapier', 'zapier', 'simple-icons:zapier'),

-- DevOps & infrastructure
('Docker', 'docker', 'logos:docker-icon'),
('Kubernetes', 'kubernetes', 'logos:kubernetes'),
('Ansible', 'ansible', 'logos:ansible'),
('Terraform', 'terraform', 'logos:terraform-icon'),
('CI/CD', 'ci-cd', 'logos:github-actions'),
('GitHub Actions', 'github-actions', 'logos:github-actions'),
('Jenkins', 'jenkins', 'logos:jenkins'),
('Cloud', 'cloud', 'mdi:cloud'),
('Linux', 'linux', 'logos:linux-tux'),
('Windows Server', 'windows-server', 'logos:microsoft-windows-icon'),
('PowerShell', 'powershell', 'devicon:powershell'),

-- Networking & security
('Networking', 'networking', 'mdi:network'),
('Firewalls', 'firewalls', 'mdi:wall-fire'),
('VPN', 'vpn', 'mdi:shield-key'),
('Security', 'security', 'mdi:shield-lock'),

-- IT & support
('Troubleshooting', 'troubleshooting', 'mdi:tools'),
('IT Support', 'it-support', 'mdi:headset'),
('Helpdesk', 'helpdesk', 'mdi:face-agent'),
('SysAdmin', 'sysadmin', 'mdi:server'),

-- CS fundamentals
('Algorithms', 'algorithms', 'mdi:function-variant'),
('Data Structures', 'data-structures', 'mdi:graph'),
('Design Patterns', 'design-patterns', 'mdi:puzzle'),
('Code Optimization', 'code-optimization', 'mdi:speedometer'),

-- Data science
('Data Visualization', 'data-visualization', 'mdi:chart-bar'),
('Pandas', 'pandas', 'logos:pandas-icon'),
('NumPy', 'numpy', 'simple-icons:numpy'),
('Scikit-Learn', 'scikit-learn', 'simple-icons:scikitlearn'),
('Matplotlib', 'matplotlib', null),

-- Climbing
('Bouldering', 'bouldering', null),
('Sport Climbing', 'sport-climbing', null),
('Trad Climbing', 'trad-climbing', null),

-- Fitness
('Training', 'training', 'mdi:dumbbell'),
('Strength Training', 'strength-training', 'mdi:dumbbell'),
('Cardio', 'cardio', 'mdi:heart-pulse'),
('HIIT', 'hiit', 'mdi:timer'),
('Yoga', 'yoga', 'mdi:meditation'),
('Flexibility', 'flexibility', 'mdi:human-greeting-variant'),
('Training Plans', 'training-plans', 'mdi:clipboard-list'),

-- Running
('Marathon', 'marathon', 'mdi:run'),
('5K', '5k', 'mdi:run'),
('10K', '10k', 'mdi:run'),
('Trail Running', 'trail-running', 'mdi:run-fast'),

-- Gear
('Gear Reviews', 'gear-reviews', 'mdi:star-circle'),
('Gear', 'gear', 'mdi:backpack');

insert into public.article_categories (name, slug, description, color)
values ('Software Development',
        'software-development',
        'Articles about programming concepts, software design patterns, tutorials, and code samples.',
        '#7c3aed'),
       ('Web Development',
        'web-development',
        'Focused on frontend and backend web development, covering topics like HTML, CSS, JavaScript, Django, and APIs.',
        '#4f46e5'),
       ('Data Science & Analytics',
        'data-science-analytics',
        'Data analysis, machine learning, and insights on handling and visualizing data with Python or other tools.',
        '#0284c7'),
       ('DevOps & Automation',
        'devops-automation',
        'Content on CI/CD, Docker, Kubernetes, server automation, and configuration management.',
        '#0891b2'),
       ('IT Infrastructure',
        'it-infrastructure',
        'Topics on networking, servers, security, and infrastructure management.',
        '#475569'),
       ('IT Operations & Support',
        'it-operations-support',
        'Day-to-day IT operations, troubleshooting, and support tips for both on-premises and cloud systems.',
        '#64748b'),
       ('Climbing',
        'climbing',
        'Personal experiences, climbing techniques, training tips, and gear recommendations for bouldering and climbing.',
        '#16a34a'),
       ('Running',
        'running',
        'Articles covering running routines, training plans, race experiences, and gear reviews.',
        '#dc2626'),
       ('Fitness',
        'fitness',
        'General fitness tips, strength training routines, flexibility exercises, and maintaining overall health.',
        '#ea580c');