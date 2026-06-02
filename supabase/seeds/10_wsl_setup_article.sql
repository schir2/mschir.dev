-- Draft article: Setting up WSL2 as a dev environment on Windows

insert into public.article_tags (name, slug, icon)
values
    ('WSL', 'wsl', 'logos:microsoft-windows-icon')
on conflict (slug) do nothing;

insert into public.articles (id, title, slug, content, category_id, author, writing_stage, published_at, created_at, updated_at)
values (
    'b1000000-0000-0000-0000-000000000010',
    'Setting Up WSL2 as a Dev Environment on Windows',
    'setting-up-wsl2-as-a-dev-environment-on-windows',
    $article$# Setting Up WSL2 as a Dev Environment on Windows

I had WSL installed for a while before I actually used it properly. The Ubuntu app was there, I could open a terminal, but I kept getting permission errors when WebStorm tried to create files, and I wasn't sure why. Turns out I had the right tool but the wrong mental model.

This is the setup I wish I had found the first time.

## What WSL2 actually is

WSL2 is not a full virtual machine. It runs a real Linux kernel inside a lightweight Hyper-V utility VM that Windows manages automatically. You don't configure it, you don't allocate a disk image manually, and you don't see it in the Hyper-V manager. Windows spins it up when you need it and keeps it running in the background.

The Ubuntu app in the Start menu and typing `wsl` in PowerShell both drop you into the same place: your Ubuntu instance, logged in as your Linux user. The difference is that opening Ubuntu from the Start menu always starts you in your Linux home directory (`/home/yourname`), while `wsl` in PowerShell inherits whatever directory PowerShell was in and mounts it as `/mnt/c/...`. That distinction matters more than it sounds.

## The filesystem split

WSL2 has two filesystems:

- **Linux filesystem** (`/home/yourname`, `~/`, etc.) -- native Linux ext4, fast
- **Windows filesystem** (`/mnt/c/Users/...`) -- your Windows C drive, mounted into Linux

You can read and write both from inside Ubuntu. But every file operation that crosses the boundary carries overhead. Running `pnpm install` on a project sitting under `/mnt/c/` can take three to five times longer than the same command on the Linux filesystem. File watchers (Vite HMR, for example) also behave badly across that boundary.

The rule is simple: code lives in `~/`, not under `/mnt/c/`.

Copying a file from Windows to Linux is fine -- that's a one-time operation. Running a build tool against Windows-hosted files is not.

## Setting up your user

Open the Ubuntu app. Run:

```bash
whoami
echo ~
```

You want `whoami` to return your username (not `root`) and `~` to resolve to `/home/yourname`. If you see `root`, you need to create a regular user and set it as the default:

```bash
# Inside Ubuntu as root
adduser yourname
usermod -aG sudo yourname
exit
```

Then from PowerShell:

```powershell
ubuntu config --default-user yourname
```

## Installing Node via nvm

Do not use a Windows-installed Node from inside WSL. Install Node natively inside Ubuntu:

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
source ~/.bashrc
nvm install --lts
nvm use --lts
node --version
```

nvm lets you switch Node versions per project. It's the standard way to manage Node on Linux.

## Installing pnpm

```bash
npm install -g pnpm
pnpm --version
```

The first time you run `pnpm install` on a project in a fresh WSL environment, you may see this:

```
[ERR_PNPM_IGNORED_BUILDS] Ignored build scripts: @parcel/watcher@x.x.x, esbuild@x.x.x
```

This is a pnpm security feature that blocks packages from running build scripts until you explicitly approve them. Run `pnpm approve-builds`, approve both packages, then re-run `pnpm install`. It's a one-time step per machine.

## Opening a project in WebStorm

Clone the project inside WSL first:

```bash
mkdir -p ~/apps
cd ~/apps
git clone git@github.com:yourname/yourproject.git
```

Then open it in WebStorm via **File > Open** using the UNC path:

```
\\wsl.localhost\Ubuntu\home\yourname\apps\yourproject
```

WebStorm detects WSL projects automatically and prompts you to configure the Node interpreter. Point it at the nvm-installed Node:

```
/home/yourname/.nvm/versions/node/v22.x.x/bin/node
```

The files stay on the fast Linux filesystem. WebStorm's UI runs on Windows. pnpm and Node run inside Ubuntu. It works well once the interpreter is set correctly.

## Common issues

| Symptom | Fix |
|---------|-----|
| `pnpm install` is very slow | Project is on `/mnt/c/` -- clone into `~/` instead |
| `ERR_PNPM_IGNORED_BUILDS` | Run `pnpm approve-builds`, approve `@parcel/watcher` and `esbuild` |
| HMR not picking up file saves | Set `fs.inotify.max_user_watches=524288` in `/etc/sysctl.conf` and run `sudo sysctl -p` |
| WebStorm uses Windows Node | Set interpreter to the WSL path in Settings > Node.js |
| `localhost:3000` not reachable | Run `wsl --shutdown` and restart; Windows firewall occasionally blocks the port |
$article$,
    (select id from public.article_categories where slug = 'devops-automation'),
    '3a455a9e-9a96-4fa1-aef9-8591690084e6',
    'draft',
    null,
    '2026-06-02 09:00:00+00',
    '2026-06-02 09:00:00+00'
);

insert into public.featured_articles (article_id, featured_reason, author)
values (
    'b1000000-0000-0000-0000-000000000010',
    'Practical setup guide for Windows developers moving to WSL2',
    '3a455a9e-9a96-4fa1-aef9-8591690084e6'
);

insert into public.article_tags_links (article_id, tag_id)
select 'b1000000-0000-0000-0000-000000000010', id
from public.article_tags
where slug in ('linux', 'powershell', 'sysadmin', 'wsl');