BEGIN;

-- ============================================================================
-- PROGRAM REQUIREMENTS (public.program_requirements)
-- 45 curriculum requirements across all 4 B.Sc. programs
-- ============================================================================
INSERT INTO public.program_requirements (
  program,
  course_id,
  category,
  recommended_semester
)
SELECT
  v.program,
  c.id AS course_id,
  v.category,
  v.recommended_semester
FROM (VALUES
  -- B.Sc. Business Administration
  ('B.Sc. Business Administration', 'BA101', 'core', 1),
  ('B.Sc. Business Administration', 'BA102', 'core', 1),
  ('B.Sc. Business Administration', 'EC101', 'core', 1),
  ('B.Sc. Business Administration', 'BA201', 'core', 2),
  ('B.Sc. Business Administration', 'BA202', 'core', 3),
  ('B.Sc. Business Administration', 'BA203', 'core', 3),
  ('B.Sc. Business Administration', 'DS101', 'elective', 4),
  ('B.Sc. Business Administration', 'IS201', 'core', 4),
  ('B.Sc. Business Administration', 'BA301', 'core', 5),
  ('B.Sc. Business Administration', 'BA302', 'elective', 5),

  -- B.Sc. Computer Science
  ('B.Sc. Computer Science', 'CS101', 'core', 1),
  ('B.Sc. Computer Science', 'MA101', 'core', 1),
  ('B.Sc. Computer Science', 'MA102', 'core', 1),
  ('B.Sc. Computer Science', 'CS102', 'core', 2),
  ('B.Sc. Computer Science', 'MA201', 'core', 2),
  ('B.Sc. Computer Science', 'CS201', 'core', 3),
  ('B.Sc. Computer Science', 'CS202', 'core', 3),
  ('B.Sc. Computer Science', 'SE101', 'core', 3),
  ('B.Sc. Computer Science', 'CS203', 'core', 4),
  ('B.Sc. Computer Science', 'CS302', 'core', 4),
  ('B.Sc. Computer Science', 'CY101', 'elective', 4),
  ('B.Sc. Computer Science', 'CS301', 'elective', 5),
  ('B.Sc. Computer Science', 'CS303', 'elective', 5),
  ('B.Sc. Computer Science', 'SE201', 'core', 5),
  ('B.Sc. Computer Science', 'SE202', 'elective', 5),
  ('B.Sc. Computer Science', 'DS201', 'elective', 6),

  -- B.Sc. Cyber Security
  ('B.Sc. Cyber Security', 'CS101', 'core', 1),
  ('B.Sc. Cyber Security', 'CY101', 'core', 1),
  ('B.Sc. Cyber Security', 'CY201', 'core', 2),
  ('B.Sc. Cyber Security', 'MA201', 'core', 2),
  ('B.Sc. Cyber Security', 'CS203', 'core', 3),
  ('B.Sc. Cyber Security', 'CY202', 'core', 3),
  ('B.Sc. Cyber Security', 'CY301', 'core', 4),
  ('B.Sc. Cyber Security', 'CY302', 'core', 5),
  ('B.Sc. Cyber Security', 'SE202', 'elective', 5),

  -- B.Sc. Data Science
  ('B.Sc. Data Science', 'CS101', 'core', 1),
  ('B.Sc. Data Science', 'DS101', 'core', 1),
  ('B.Sc. Data Science', 'MA101', 'core', 1),
  ('B.Sc. Data Science', 'DS202', 'core', 2),
  ('B.Sc. Data Science', 'MA202', 'core', 2),
  ('B.Sc. Data Science', 'CS302', 'core', 3),
  ('B.Sc. Data Science', 'DS201', 'core', 3),
  ('B.Sc. Data Science', 'DS301', 'core', 4),
  ('B.Sc. Data Science', 'CS303', 'elective', 5),
  ('B.Sc. Data Science', 'DS302', 'elective', 5)
) AS v(program, course_code, category, recommended_semester)
JOIN public.courses c ON c.code = v.course_code
ON CONFLICT (program, course_id) DO UPDATE SET
  category = EXCLUDED.category,
  recommended_semester = EXCLUDED.recommended_semester;

COMMIT;
