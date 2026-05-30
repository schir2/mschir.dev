# WSL Development Setup

Guide for running this project inside WSL2 instead of Windows native.
The project must live in the WSL filesystem (not under `/mnt/c/`) for acceptable performance.

## Prerequisites

- WSL2 installed with a Linux distro (Ubuntu recommended)
- WebStorm with WSL SDK configured

---

## 1. Open a WSL terminal

Open Ubuntu from the Start menu (or Windows Terminal → Ubuntu tab).

**Important:** typing `wsl` inside PowerShell lands you in `/mnt/c/...` — the slow Windows-mapped
filesystem. Always work from the WSL-native home directory instead:

```bash
cd ~
```

---

## 2. Install Node.js via nvm

Do not use a Windows-installed Node from `/mnt/c/`. Install Node natively inside WSL:

```bash
# Check if nvm is already installed
nvm -v

# If not, install it
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Restart the terminal, then install the LTS Node version
nvm install --lts
nvm use --lts
```

---

## 3. Install pnpm

```bash
# Check if pnpm is already installed
pnpm -v

# If not
npm install -g pnpm
```

---

## 4. Set up GitHub authentication inside WSL

WSL does not share SSH keys with Windows automatically. Pick one option:

**Option A — Copy existing Windows SSH keys:**
```bash
cp /mnt/c/Users/schir/.ssh/id_* ~/.ssh/
chmod 600 ~/.ssh/id_rsa ~/.ssh/id_ed25519 2>/dev/null
```

**Option B — Generate new WSL SSH keys:**
```bash
ssh-keygen -t ed25519 -C "schir2@gmail.com"
cat ~/.ssh/id_ed25519.pub
# Add the printed key to GitHub → Settings → SSH Keys
```

---

## 5. Clone the repository

```bash
mkdir -p ~/dev && cd ~/dev
git clone git@github.com:schir2/mschir.dev.git
cd mschir.dev
```

---

## 6. Copy environment files from the Windows project

```bash
cp /mnt/c/Users/schir/Desktop/dev/mschir.dev/.env* ~/dev/mschir.dev/
```

---

## 7. Install dependencies

```bash
pnpm install
```

---

## 8. Fix inotify watch limit (one-time, prevents Vite/Nuxt HMR issues)

```bash
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

---

## 9. Install Supabase CLI

Required for `pnpm run supabase:types` and `pnpm run db:reset`:

```bash
# Check if already available via pnpm install
pnpm supabase --version

# If not found globally, install it
pnpm install -g supabase
```

---

## 10. Open in WebStorm

**Option A — Clone via WebStorm directly (skips steps 5–6 above):**
1. File → Get from VCS
2. Enter the GitHub repo URL
3. Set the directory to `\\wsl$\Ubuntu\home\schir\dev\mschir.dev`
4. Click Clone
5. Still copy `.env` files manually (step 6 above)

**Option B — Open an already-cloned project:**
1. File → Open
2. Navigate to `\\wsl$\Ubuntu\home\schir\dev\mschir.dev`

WebStorm should auto-detect the WSL Node interpreter. If it doesn't:
Settings → Languages & Frameworks → Node.js → set interpreter to the WSL path
(e.g., `/home/schir/.nvm/versions/node/v22.x.x/bin/node`)

---

## Verify everything works

```bash
pnpm run dev
```

Open `http://localhost:3000` in your Windows browser — it resolves through WSL2's port forwarding automatically.

---

## Common issues

| Symptom | Fix |
|---------|-----|
| `pnpm install` very slow | Project is on `/mnt/c/` — clone into `~/dev/` instead |
| HMR not picking up file saves | inotify limit not set — see step 8 |
| `supabase` command not found | Install globally via step 9 |
| WebStorm uses Windows Node | Point interpreter to WSL path in Settings → Node.js |
| `localhost:3000` not reachable | Run `wsl --shutdown` and restart WSL; Windows firewall occasionally blocks the port |