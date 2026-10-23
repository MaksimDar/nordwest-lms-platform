# Deployment

Two independent options. Netlify builds from Git and does not use the Dockerfile.

## 1. Docker (optional, local or any container host)

Requires Docker Desktop and a `.env` file (copy `.env.example` and fill it in).

```bash
docker compose up --build
```

Open http://localhost:3000. Stop with Ctrl+C, or `docker compose down`.

- The `VITE_` values are public and are baked into the browser bundle at build time. After changing
  them, rebuild with `docker compose up --build`.
- Server-side values (`SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `AI_API_KEY`, ...) are read from
  `.env` at runtime and are never stored in the image. `.dockerignore` keeps `.env` out of the image.
- Use `docker compose`, not `docker run --env-file .env`: `docker run` keeps the quotes in
  `AI_API_KEY="..."` as part of the value.
- `docker ps` should show the container as `healthy` after a few seconds.

## 2. Netlify

1. Push the repository to GitHub (branch `main`).
2. app.netlify.com > Add new project > Import an existing project > GitHub > choose the repository.
3. Build settings come from `netlify.toml` (command `npm run build`, publish `dist`, Node 22,
   Nitro preset `netlify`). Do not change them.
4. Before the first deploy, add these environment variables (Project configuration > Environment
   variables). Keep the default scopes.

   | Variable | Value | Notes |
   |---|---|---|
   | `SUPABASE_URL` | `https://<project-ref>.supabase.co` | no `/rest/v1/` at the end |
   | `VITE_SUPABASE_URL` | same as above | |
   | `SUPABASE_PUBLISHABLE_KEY` | `sb_publishable_...` | do NOT mark as secret |
   | `VITE_SUPABASE_PUBLISHABLE_KEY` | same as above | do NOT mark as secret |
   | `AI_API_KEY` | your provider key | mark as secret |
   | `AI_BASE_URL` | e.g. `https://api.groq.com/openai/v1` | |
   | `AI_MODEL` | e.g. `openai/gpt-oss-120b` | |
   | `AI_PROVIDER` | `compatible` | |
   | `AI_REASONING` | `low` | optional, reasoning models only |

   Do not set `AI_DEBUG` in production.
5. Deploy. After any change to environment variables, trigger a new deploy.
6. In Supabase: Authentication > URL Configuration > set Site URL to your Netlify address.
7. Log in as the lecturer and as a student, open the chat assistant, and check an AI summary.

### Troubleshooting

- **Build fails with "Secrets scanning found secrets":** the public Supabase key is part of the browser
  bundle. Add the variable `SECRETS_SCAN_SMART_DETECTION_ENABLED` = `false`. The AI key is not affected,
  because it is only used on the server.
- **Chat or AI features fail:** check Netlify > Logs > Functions, and that all server variables above
  exist. Redeploy after adding them.
- **Node version errors:** make sure `NODE_VERSION` is `22` (set in `netlify.toml`).
- **Fallback host:** the project also builds for Vercel (the preset is detected automatically).