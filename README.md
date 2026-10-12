# NordWest LMS

Learning Management System prototype for NordWest Business School, built for the course
*Project: Agile Software Engineering*. It implements the Sprint 1 scope of the project report:
the four lecturer lifecycle stages (meetMyStudent, teachMyStudent, testMyStudent, gradeMyStudent),
a student portal, exam eligibility (BR-01..03), controlled result publication (BR-07/08) and
four AI features (FR-23..26).

<!-- Add an AI-assistance disclosure here if your course requires one. -->

## Stack

React 19 + TypeScript, TanStack Start (routing, server functions, API route), Tailwind CSS 4,
Supabase (PostgreSQL, Auth, Storage, Row Level Security), Vercel AI SDK (server-side only).

## Setup

Requires **Node 22 or newer**.

```bash
npm install
cp .env.example .env      # then fill in the values
npm run dev
```

### 1. Supabase project

1. Create a project at supabase.com and copy the URL and publishable key
   (Project Settings -> API) into `.env`.
2. In the SQL Editor, run the files in `drizzle/migrations/` **in order**: `0000`, `0001`, `0002`,
   `0003`, `0004`.
3. Storage -> create a **private** bucket named `course-materials` (policies come from `0001`).
4. Authentication -> Sign In / Providers -> turn **off** "Allow new users to sign up"
   (accounts are created by an administrator; the app has no sign-up page).
5. Authentication -> Users -> Add user (tick "Auto Confirm User"):
   `anna.mueller@nordwest.edu` and `max.schneider@nordwest.edu`, both with the demo password
   in `src/lib/demo.ts`. Then promote the lecturer in the SQL Editor:

   ```sql
   update public.user_roles set role = 'lecturer'
    where user_id = (select id from auth.users where email = 'anna.mueller@nordwest.edu');
   update public.profiles set full_name = 'Prof. Dr. Anna Müller'
    where id = (select id from auth.users where email = 'anna.mueller@nordwest.edu');
   update public.profiles set full_name = 'Max Schneider', study_course = 'B.Sc. Computer Science', semester_level = 3
    where id = (select id from auth.users where email = 'max.schneider@nordwest.edu');
   ```

### 2. AI provider

Set `AI_API_KEY` (and optionally `AI_MODEL`, `AI_BASE_URL`) in `.env`. The key is read on the server
only. Without it, the app works but the chat assistant, material summaries and draft feedback return an
error message.

## Scripts

`npm run dev` · `npm run build` · `npm run typecheck` · `npm run lint`

## Known limitations

- No persistent audit log of grading and publication events (NFR-07 not yet met).
- Notifications are in-app only; no email delivery (NFR-10).
- Virtual-class and calendar integrations are stored links, not live Teams or calendar API calls.
- The demo password is shared and public; use demo accounts only, never real data.
