# NordWest LMS

Learning Management System prototype for NordWest Business School, developed for the course
*Project: Agile Software Engineering*. It implements the Sprint 1 scope of the project report:
the four lecturer lifecycle stages (meetMyStudent, teachMyStudent, testMyStudent, gradeMyStudent),
a student portal, exam eligibility checks (BR-01 to BR-03), controlled result publication
(BR-07, BR-08) and four AI-supported features (FR-23 to FR-26).

**Live demo:** https://lms-nordwest.netlify.app

<!-- Add an AI-assistance disclosure here if your course requires one. -->

## Demo sign-in

The login page offers one-click sign-in for two default users:

- **Prof. Dr. Anna Müller** (lecturer)
- **Max Schneider** (student)

A banner in the application switches between the two profiles, so a workflow can be followed
from both sides. All accounts and data are fictional.

## Stack

React 19 and TypeScript, TanStack Start (routing, server functions, API route), Tailwind CSS 4,
Supabase (PostgreSQL, Authentication, Storage, Row Level Security), and the Vercel AI SDK
(server-side only).

## Project structure

```
src/routes/_authenticated/   lifecycle stages: meet, teach, test, grade, portal
src/lib/ai/gateway.server.ts AI provider access (FR-23 to FR-26)
src/lib/ai.functions.ts      summaries, draft feedback, at-risk scoring
drizzle/migrations/          versioned SQL migrations, run in order
Dockerfile                   container build (multi-stage)
DEPLOYMENT.md                Netlify and Docker deployment
```

## Requirements traceability

| Requirement | Implementation |
|---|---|
| BR-01 to BR-03 (exam eligibility) | Eligibility filter in `src/routes/_authenticated/test.tsx`, shown to students in the portal |
| BR-07, BR-08 (controlled publication) | Publish action disabled until at least one submission is graded; notification on publication |
| BR-10 (role-based access) | Interface checks plus Row Level Security policies in `drizzle/migrations/` |
| FR-23 (AI assistant) | Chat route `src/routes/api/chat.ts` |
| FR-24, FR-25 (AI summaries and draft feedback) | `src/lib/ai.functions.ts` |
| FR-26 (at-risk flagging) | Rule-based scoring in `src/components/AtRiskPanel.tsx` |

## Setup

Requires **Node 22 or newer** (see `.nvmrc`).

```bash
npm install
cp .env.example .env     # then fill in the values
npm run dev
```

### 1. Supabase project

1. Create a project at supabase.com. Copy the project URL and the publishable key
   (Project Settings > API) into `.env`.
2. In the SQL Editor, run the files in `drizzle/migrations/` **in order**: `0000`, `0001`, `0002`,
   `0003`, `0004`.
3. In Storage, create a **private** bucket named `course-materials`. The policies come from `0001`.
4. In Authentication > Sign In / Providers, turn **off** "Allow new users to sign up". Accounts are
   created by an administrator; the application has no sign-up page.
5. In Authentication > Users, add `anna.mueller@nordwest.edu` and `max.schneider@nordwest.edu`
   with **Auto Confirm User** ticked. Use the demo password from `src/lib/demo.ts`. Then run:

   ```sql
   update public.user_roles set role = 'lecturer'
    where user_id = (select id from auth.users where email = 'anna.mueller@nordwest.edu');
   update public.profiles set full_name = 'Prof. Dr. Anna Müller'
    where id = (select id from auth.users where email = 'anna.mueller@nordwest.edu');
   update public.profiles set full_name = 'Max Schneider', study_course = 'B.Sc. Computer Science', semester_level = 3
    where id = (select id from auth.users where email = 'max.schneider@nordwest.edu');
   ```

### 2. Environment variables

| Variable | Required | Purpose |
|---|---|---|
| `SUPABASE_URL` | yes | Project URL, without `/rest/v1/` |
| `SUPABASE_PUBLISHABLE_KEY` | yes | Public client key (`sb_publishable_...`) |
| `VITE_SUPABASE_URL` | yes | Same value as `SUPABASE_URL`, for the browser build |
| `VITE_SUPABASE_PUBLISHABLE_KEY` | yes | Same value as `SUPABASE_PUBLISHABLE_KEY`, for the browser build |
| `AI_API_KEY` | for AI features | Provider key. Server only, never commit it |
| `AI_BASE_URL` | no | OpenAI-compatible endpoint, for example `https://api.groq.com/openai/v1` |
| `AI_MODEL` | no | Model name from the provider's model list |
| `AI_PROVIDER` | no | `compatible` (default) or `openai` |
| `AI_REASONING` | no | `low`, `medium` or `high`, for reasoning models only |
| `AI_DEBUG` | no | Set to `1` to show provider error text in the chat. Development only |

Without `AI_API_KEY`, the application runs, but the chat assistant, summaries and draft feedback
return an error message.

## Run with Docker

Requires Docker Desktop and a filled-in `.env` file.

```bash
docker compose up --build
```

Open http://localhost:3000. Server-side values are read from `.env` at runtime and are not stored
in the image. Changes to `VITE_` values require a rebuild with `--build`.

## Deployment

The application is deployed on Netlify from this repository. `netlify.toml` contains the build
settings. Step-by-step instructions, including the environment variables to set on Netlify, are in
[`DEPLOYMENT.md`](DEPLOYMENT.md).

## Scripts

| Command | Purpose |
|---|---|
| `npm run dev` | Development server on http://localhost:8080 |
| `npm run build` | Production build |
| `npm run typecheck` | TypeScript check, no output |
| `npm run lint` | ESLint |

## Testing

The project has no automated tests. It was verified manually: the Sprint 1 workflows were run
end to end on the deployed application with the two demo users.

## Known limitations

- No persistent audit log of grading and publication events (NFR-07 not yet met).
- Notifications are in-app only; no e-mail delivery (NFR-10).
- Virtual-class and calendar integrations are stored links, not live Microsoft Teams or calendar
  API calls.
- Role-based interfaces exist for lecturers and students; dedicated Examination Office and IT
  administration views are not implemented.
- The demo password is shared and documented in this repository. Use demo accounts only, never
  real data, and do not reuse the password anywhere else.

## Acknowledgements

Developed with AI-assisted tooling during development. <!-- Replace with the exact disclosure your course requires. -->
