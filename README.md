# KatChat 🐱 — Premium Real-Time Chat App v2.1

A modern full-stack real-time messaging platform with AI assistant Sage, global chat, private messaging, role management, announcements with comments, and a polished mobile-first UI.

---

## ✨ Features at a Glance

| Feature | Details |
|---|---|
| 💬 Private Chat | Real-time, replies, image upload (5 max), swipe-to-reply |
| 🌐 Global Chat | @mentions, owner glow effect, /commands with user autocomplete |
| 👥 Friends | Search, requests, mutual friends, online status |
| 📢 Announcements | Images, pinning, comments (banned users view-only) |
| 🤖 Sage AI | Groq (free & fast), chat history (5 exchanges), image analysis |
| 🏷️ Roles | Custom roles — name, color, Font Awesome icon, permissions |
| 🛡️ Admin Panel | Ban with reason, unban, role assign, post management |
| 👑 Owner | Glowing messages, crown badge, full control |
| 📱 Mobile | Swipe-to-reply, responsive, PWA manifest |
| 🎨 Themes | Dark/Light per user, persisted to DB |
| 🔍 SEO | Meta, Open Graph, Twitter Card, JSON-LD |

---

## 🛠️ Tech Stack

- **Backend:** Node.js, Express, Socket.io
- **Database:** Supabase (PostgreSQL)
- **AI:** Groq (primary, free) / Anthropic (fallback)
- **Frontend:** Vanilla JS SPA, CSS3, Font Awesome 6

---

## 🚀 Setup — Step by Step

### Step 1 — Supabase

1. Sign up at **https://supabase.com** → Create project
2. Go to **SQL Editor → New Query**
3. Paste all contents of `backend/schema.sql` → Click **Run**
4. Go to **Project Settings → API** and copy:
   - **Project URL** → `SUPABASE_URL`
   - **service_role** secret key → `SUPABASE_SERVICE_KEY`

---

### Step 2 — Groq AI Key (Free, takes 30 seconds)

1. Go to **https://console.groq.com**
2. Sign up / log in
3. Click **API Keys → Create API Key**
4. Copy the key (starts with `gsk_...`)
5. Paste as `GROQ_API_KEY` in your `.env`

> Groq gives you free access to Llama 3.3, Mixtral, and vision models. No credit card needed.

**Available Models:**
| Variable | Recommended Value |
|---|---|
| `GROQ_MODEL` | `llama-3.3-70b-versatile` (best quality) |
| `GROQ_VISION_MODEL` | `meta-llama/llama-4-scout-17b-16e-instruct` (image analysis) |

---

### Step 3 — Fill in .env

Open `backend/.env` and fill in all values:

```env
PORT=5000
SUPABASE_URL=https://xxxxxxxxxxxx.supabase.co
SUPABASE_SERVICE_KEY=eyJhbGci...

JWT_SECRET=make_this_long_and_random_change_me_now

# Groq (primary AI — get free key at console.groq.com)
GROQ_API_KEY=gsk_xxxxxxxxxxxxxxxxxxxx
GROQ_MODEL=llama-3.3-70b-versatile
GROQ_VISION_MODEL=meta-llama/llama-4-scout-17b-16e-instruct

# Anthropic (optional fallback)
ANTHROPIC_API_KEY=sk-ant-...

NODE_ENV=development
```

---

### Step 4 — Install & Run

```bash
cd katchat2/backend
npm install
npm run dev
```

You should see:
```
✅ Supabase connected
🚀 KatChat running on http://localhost:5000
```

Open **http://localhost:5000** in your browser.

---

### Step 5 — Owner Account

Sign up with **`chandkris27@gmail.com`** — this email is automatically assigned the **Owner** role.

---

## 👑 Roles

| Role | Color | Permissions |
|------|-------|-------------|
| member | Gray | Chat, global, view announcements, comment |
| admin | Cyan | + Ban users, delete messages, create announcements, admin panel |
| owner | Red | + Manage roles, manage users, full control, glowing messages |
| Custom | Any | Configurable in Admin Panel → Roles |

---

## 💬 Admin Commands (Global Chat)

```
/ban @username "reason"         — Permanently ban
/unban @username                — Remove ban
/tban @username 2.5 "reason"    — Temp ban for 2.5 hours
/tunban @username               — Remove temp ban early
```

Type `/` to see command suggestions. Type `@` after the command to search users.

---

## 🖼️ Adding Your Own Logos

Replace these files:
- `frontend/public/assets/logo.png` — KatChat main logo (256×256 PNG)
- `frontend/public/assets/sage-logo.png` — Sage AI icon (256×256 PNG, will rotate)
- `frontend/public/assets/favicons/favicon.ico` — Browser tab icon
- `frontend/public/assets/favicons/favicon-32x32.png`
- `frontend/public/assets/favicons/apple-touch-icon.png`

---

## 🌐 Deploy on Render

1. Push project to GitHub
2. Go to **https://render.com** → New Web Service
3. Connect your GitHub repo
4. Settings:
   - **Root Directory:** `backend`
   - **Build Command:** `npm install`
   - **Start Command:** `node server.js`
5. Add all environment variables from `.env`
6. Click **Create Web Service**

Update the canonical URL in `frontend/public/index.html`:
```html
<link rel="canonical" href="https://your-app.onrender.com/">
```

---

## 🔧 Troubleshooting

| Problem | Fix |
|---------|-----|
| `Supabase error` | Wrong URL or key in `.env` — use service_role, not anon |
| `Request failed` (signup/login) | Re-run `schema.sql` in Supabase SQL Editor |
| Sage not responding | Check `GROQ_API_KEY` in `.env`, get free key at console.groq.com |
| Images too large | Already compressed client-side — max 800px before sending |
| Online status not working | Works correctly after deploy; locally, the 30s heartbeat syncs it |
| Owner glow not showing | Only shows on OTHER users' messages when they have Owner role |
| Ban not immediate | Fixed — ban now updates instantly via socket without page refresh |

---

## 📋 Changed Files Reference (v2.1)

| File | What Changed |
|------|-------------|
| `backend/schema.sql` | Added `ban_reason`, `announcement_comments`, auto-cleanup trigger — **re-run in Supabase** |
| `backend/routes/ai.js` | Groq as primary AI, full KatChat context in system prompt |
| `backend/routes/announcements.js` | Comments CRUD endpoints |
| `backend/routes/users.js` | Ban reason field |
| `backend/socket/index.js` | Immediate ban/unban, `admin_ban_user`, `admin_unban_user` events |
| `backend/.env` | Added Groq keys |
| `frontend/public/index.html` | PNG logos, topbar beam div, slogan, favicons, read-more about |
| `frontend/public/assets/logo.png` | New PNG logo (replaces SVG) |
| `frontend/public/assets/sage-logo.png` | New PNG logo (replaces SVG) |
| `frontend/public/assets/favicons/` | All favicon PNGs + ICO |
| `frontend/public/css/style.css` | Fixed owner glow, bubble width, topbar beam animation |
| `frontend/public/js/global.js` | Fixed command dropdown with user suggestions, no skeleton flash |
| `frontend/public/js/admin.js` | Working ban button with reason dialog |
| `frontend/public/js/socket-client.js` | Instant ban/unban UI, heartbeat |
| `frontend/public/js/sage.js` | Image compression, Groq-compatible |
| `frontend/public/js/announcements.js` | Comments system |
| `frontend/public/js/settings.js` | Read-more about section |
