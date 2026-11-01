BEGIN;

-- ============================================================================
-- 1. COURSE MATERIALS (public.materials)
-- ============================================================================
INSERT INTO public.materials (
  course_id,
  title,
  kind,
  lecture_date,
  url,
  file_path,
  notes,
  ai_summary,
  summary_status
)
SELECT 
  c.id,
  v.title,
  v.kind,
  v.lecture_date::date,
  v.url,
  v.file_path,
  v.notes,
  v.ai_summary,
  v.summary_status
FROM (VALUES
  (
    'CS201',
    'Lecture 2 – Big-O notation',
    'slides',
    '2026-09-18',
    'https://en.wikipedia.org/wiki/Big_O_notation',
    NULL,
    'Big-O describes an upper bound on growth rate. Common classes: O(1) constant, O(log n) logarithmic (binary search), O(n) linear, O(n log n) (merge sort), O(n^2) quadratic (bubble sort). Drop constants and lower-order terms. Best, average and worst case differ; amortised analysis averages over sequences of operations.',
    NULL,
    'none'
  ),
  (
    'SE101',
    'Lecture 3 – Scrum roles and events',
    'slides',
    '2026-09-18',
    'https://scrumguides.org/scrum-guide.html',
    NULL,
    'The Scrum Team consists of one Scrum Master, one Product Owner and Developers. Events: the Sprint (max one month), Sprint Planning (max 8h for a one-month sprint), Daily Scrum (15 minutes), Sprint Review and Sprint Retrospective. Artefacts: Product Backlog with the Product Goal, Sprint Backlog with the Sprint Goal, and the Increment with the Definition of Done. Empiricism rests on transparency, inspection and adaptation.',
    NULL,
    'none'
  )
) AS v(course_code, title, kind, lecture_date, url, file_path, notes, ai_summary, summary_status)
JOIN public.courses c ON c.code = v.course_code
WHERE NOT EXISTS (
  SELECT 1 FROM public.materials m
  WHERE m.course_id = c.id AND m.title = v.title
);

-- ============================================================================
-- 2. NOTIFICATIONS (public.notifications)
-- ============================================================================
INSERT INTO public.notifications (
  recipient_id,
  sender_id,
  title,
  body,
  read,
  created_at
)
SELECT
  ru.id AS recipient_id,
  su.id AS sender_id,
  v.title,
  v.body,
  v.read::boolean,
  v.created_at::timestamptz
FROM (VALUES
  (
    'elias.hartmann@nordwest.edu',
    'anna.mueller@nordwest.edu',
    'New project: do it',
    'Please check your portal.',
    FALSE,
    '2026-09-25 18:25:11.317455+00'
  ),
  (
    'jonas.becker@nordwest.edu',
    'anna.mueller@nordwest.edu',
    'New project: do it',
    'Please check your portal.',
    FALSE,
    '2026-09-25 18:25:11.317455+00'
  ),
  (
    'laura.krause@nordwest.edu',
    'anna.mueller@nordwest.edu',
    'New project: do it',
    'Please check your portal.',
    FALSE,
    '2026-09-25 18:25:11.317455+00'
  ),
  (
    'tim.meier@nordwest.edu',
    'anna.mueller@nordwest.edu',
    'New project: do it',
    'Please check your portal.',
    FALSE,
    '2026-09-25 18:25:11.317455+00'
  )
) AS v(recipient_email, sender_email, title, body, read, created_at)
JOIN auth.users ru ON ru.email = v.recipient_email
LEFT JOIN auth.users su ON su.email = v.sender_email
WHERE NOT EXISTS (
  SELECT 1 FROM public.notifications n
  WHERE n.recipient_id = ru.id AND n.title = v.title
);

COMMIT;