BEGIN;

-- ============================================================================
-- TIMETABLE EVENTS (public.timetable_events - 6 weekly lecture slots)
-- ============================================================================
INSERT INTO public.timetable_events (
  course_id,
  lecturer_id,
  title,
  kind,
  starts_at,
  ends_at,
  meeting_url
)
SELECT
  c.id AS course_id,
  COALESCE(u.id, (SELECT id FROM auth.users LIMIT 1)) AS lecturer_id,
  v.title,
  v.kind,
  v.starts_at::timestamptz,
  v.ends_at::timestamptz,
  v.meeting_url
FROM (
  VALUES
    ('CS101', 'anna.mueller@nordwest.edu', 'CS101 Lecture', 'lecture', '2026-09-21 09:00:00+00', '2026-09-21 10:30:00+00', 'https://teams.microsoft.com'),
    ('SE202', 'anna.mueller@nordwest.edu', 'SE202 Lecture', 'lecture', '2026-09-21 15:00:00+00', '2026-09-21 16:30:00+00', 'https://teams.microsoft.com'),
    ('CS102', 'anna.mueller@nordwest.edu', 'CS102 Lecture', 'lecture', '2026-09-22 13:00:00+00', '2026-09-22 14:30:00+00', 'https://teams.microsoft.com'),
    ('CS201', 'anna.mueller@nordwest.edu', 'CS201 Lecture', 'lecture', '2026-09-23 09:00:00+00', '2026-09-23 10:30:00+00', 'https://teams.microsoft.com'),
    ('SE101', 'anna.mueller@nordwest.edu', 'SE101 Lecture', 'lecture', '2026-09-24 13:00:00+00', '2026-09-24 14:30:00+00', 'https://teams.microsoft.com'),
    ('SE201', 'anna.mueller@nordwest.edu', 'SE201 Lecture', 'lecture', '2026-09-25 09:00:00+00', '2026-09-25 10:30:00+00', 'https://teams.microsoft.com')
) AS v(course_code, lecturer_email, title, kind, starts_at, ends_at, meeting_url)
LEFT JOIN public.courses c ON c.code = v.course_code
LEFT JOIN auth.users u ON u.email = v.lecturer_email
WHERE NOT EXISTS (
  SELECT 1 FROM public.timetable_events te
  WHERE te.title = v.title 
    AND te.starts_at = v.starts_at::timestamptz
);

COMMIT;
