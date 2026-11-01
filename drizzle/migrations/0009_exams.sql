BEGIN;

-- ============================================================================
-- 1. EXAMS (public.exams)
-- ============================================================================
INSERT INTO public.exams (course_id, title, scheduled_at, status, results_published)
SELECT c.id, 'CS201 Quiz: Complexity', '2026-09-25 18:06:05.28+00'::timestamptz, 'released', FALSE
FROM public.courses c
WHERE c.code = 'CS201'
  AND NOT EXISTS (
    SELECT 1 FROM public.exams e WHERE e.course_id = c.id AND e.title = 'CS201 Quiz: Complexity'
  );

INSERT INTO public.exams (course_id, title, scheduled_at, status, results_published)
SELECT c.id, 'SE101 Midterm Examination', '2026-09-22 18:06:05.28+00'::timestamptz, 'released', FALSE
FROM public.courses c
WHERE c.code = 'SE101'
  AND NOT EXISTS (
    SELECT 1 FROM public.exams e WHERE e.course_id = c.id AND e.title = 'SE101 Midterm Examination'
  );

-- ============================================================================
-- 2. EXAM QUESTIONS (public.exam_questions)
-- ============================================================================
-- Questions for CS201 Quiz
INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 1, 'multiple_choice', 'What is the worst-case time complexity of binary search?', '["O(1)", "O(log n)", "O(n)", "O(n log n)"]'::jsonb, 'O(log n)', 2
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'CS201' AND e.title = 'CS201 Quiz: Complexity'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 1);

INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 2, 'yes_no', 'Is merge sort a stable sorting algorithm?', '["Yes", "No"]'::jsonb, 'Yes', 1
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'CS201' AND e.title = 'CS201 Quiz: Complexity'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 2);

INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 3, 'mathematical', 'How many edges does a complete graph with 6 vertices have?', '[]'::jsonb, '15', 2
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'CS201' AND e.title = 'CS201 Quiz: Complexity'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 3);

-- Questions for SE101 Midterm
INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 1, 'multiple_choice', 'Which Scrum event is time-boxed to a maximum of 15 minutes?', '["Sprint Review", "Daily Scrum", "Sprint Retrospective", "Sprint Planning"]'::jsonb, 'Daily Scrum', 2
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'SE101' AND e.title = 'SE101 Midterm Examination'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 1);

INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 2, 'yes_no', 'Is the Product Owner responsible for maximising the value of the product?', '["Yes", "No"]'::jsonb, 'Yes', 1
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'SE101' AND e.title = 'SE101 Midterm Examination'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 2);

INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 3, 'multiple_choice', 'Which artefact contains the work selected for the current sprint?', '["Product Backlog", "Sprint Backlog", "Increment", "Roadmap"]'::jsonb, 'Sprint Backlog', 2
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'SE101' AND e.title = 'SE101 Midterm Examination'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 3);

INSERT INTO public.exam_questions (exam_id, "position", kind, prompt, options, correct_answer, marks)
SELECT e.id, 4, 'essay', 'Explain how user story mapping helps a team plan releases. Give one example.', '[]'::jsonb, NULL, 5
FROM public.exams e JOIN public.courses c ON c.id = e.course_id
WHERE c.code = 'SE101' AND e.title = 'SE101 Midterm Examination'
  AND NOT EXISTS (SELECT 1 FROM public.exam_questions q WHERE q.exam_id = e.id AND q.position = 4);

-- ============================================================================
-- 3. EXAM ATTEMPTS (public.exam_attempts)
-- ============================================================================
INSERT INTO public.exam_attempts (exam_id, student_id, submitted_at, score, max_score, graded, feedback)
SELECT 
  e.id,
  u.id,
  v.submitted_at::timestamptz,
  v.score::numeric,
  v.max_score::numeric,
  v.graded::boolean,
  v.feedback
FROM (VALUES
  ('SE101', 'SE101 Midterm Examination', 'david.koehler@nordwest.edu', '2026-09-25 11:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'finn.werner@nordwest.edu', '2026-09-25 14:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'ivan.petrov@nordwest.edu', '2026-09-25 08:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'julia.huber@nordwest.edu', '2026-09-25 10:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'laura.krause@nordwest.edu', '2026-09-25 13:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'lukas.richter@nordwest.edu', '2026-09-25 16:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'max.schneider@nordwest.edu', NULL, NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'mehmet.yilmaz@nordwest.edu', '2026-09-25 09:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'nora.berg@nordwest.edu', '2026-09-25 07:06:05.28+00', NULL, NULL, FALSE, 'You correctly identified two Scrum fundamentals, but you need to review Product Owner responsibilities and develop your explanation of user story mapping.

Q1: You correctly chose the Daily Scrum, which is time-boxed to a maximum of 15 minutes.
Q2: Your answer should be "Yes": the Product Owner is accountable for maximising the value of the product.
Q3: You correctly identified the Sprint Backlog as the artefact containing the work selected for the current sprint.
Q4: You suggest that story maps help the team, but describing them as "drawing" does not explain release planning, and you have not provided an example. Explain how mapping stories around user activities helps prioritise and group work into releases. For example, a shopping app''s first release might support browsing and checkout, with wish lists added later.

For revision, practise explaining each concept''s purpose and supporting it with a concrete example.'),
  ('SE101', 'SE101 Midterm Examination', 'paul.wolf@nordwest.edu', '2026-09-25 15:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'sophie.hoffmann@nordwest.edu', '2026-09-25 17:06:05.28+00', NULL, NULL, FALSE, ''),
  ('SE101', 'SE101 Midterm Examination', 'tim.meier@nordwest.edu', '2026-09-25 12:06:05.28+00', NULL, NULL, FALSE, '')
) AS v(course_code, exam_title, student_email, submitted_at, score, max_score, graded, feedback)
JOIN public.courses c ON c.code = v.course_code
JOIN public.exams e ON e.course_id = c.id AND e.title = v.exam_title
JOIN auth.users u ON u.email = v.student_email
ON CONFLICT (exam_id, student_id) DO UPDATE SET
  submitted_at = EXCLUDED.submitted_at,
  score = EXCLUDED.score,
  max_score = EXCLUDED.max_score,
  graded = EXCLUDED.graded,
  feedback = EXCLUDED.feedback;

-- ============================================================================
-- 4. EXAM ANSWERS (public.exam_answers)
-- ============================================================================
INSERT INTO public.exam_answers (attempt_id, question_id, response, awarded_marks, auto_marked)
SELECT
  att.id AS attempt_id,
  q.id AS question_id,
  v.response,
  v.awarded_marks::numeric,
  v.auto_marked::boolean
FROM (VALUES
  ('SE101', 'SE101 Midterm Examination', 'david.koehler@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'david.koehler@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'david.koehler@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'david.koehler@nordwest.edu', 4, 'Story maps are about drawing. I think they help the team.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'finn.werner@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'finn.werner@nordwest.edu', 2, 'No', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'finn.werner@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'finn.werner@nordwest.edu', 4, 'User story mapping arranges stories along the user journey so the team can slice a walking skeleton as the first release, e.g. login, browse and checkout in an online shop.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'ivan.petrov@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'ivan.petrov@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'ivan.petrov@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'ivan.petrov@nordwest.edu', 4, 'Story maps are about drawing. I think they help the team.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'julia.huber@nordwest.edu', 1, 'Sprint Planning', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'julia.huber@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'julia.huber@nordwest.edu', 3, 'Roadmap', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'julia.huber@nordwest.edu', 4, 'User story mapping arranges stories along the user journey so the team can slice a walking skeleton as the first release, e.g. login, browse and checkout in an online shop.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'laura.krause@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'laura.krause@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'laura.krause@nordwest.edu', 3, 'Roadmap', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'laura.krause@nordwest.edu', 4, 'User story mapping arranges stories along the user journey so the team can slice a walking skeleton as the first release, e.g. login, browse and checkout in an online shop.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'lukas.richter@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'lukas.richter@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'lukas.richter@nordwest.edu', 3, 'Increment', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'lukas.richter@nordwest.edu', 4, 'By organising activities horizontally and priorities vertically, the team sees gaps and can plan MVP releases; in our LMS project we released meetMyStudent first.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'mehmet.yilmaz@nordwest.edu', 1, 'Sprint Planning', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'mehmet.yilmaz@nordwest.edu', 2, 'No', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'mehmet.yilmaz@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'mehmet.yilmaz@nordwest.edu', 4, 'Story maps are about drawing. I think they help the team.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'nora.berg@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'nora.berg@nordwest.edu', 2, 'No', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'nora.berg@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'nora.berg@nordwest.edu', 4, 'Story maps are about drawing. I think they help the team.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'paul.wolf@nordwest.edu', 1, 'Sprint Retrospective', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'paul.wolf@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'paul.wolf@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'paul.wolf@nordwest.edu', 4, 'User story mapping arranges stories along the user journey so the team can slice a walking skeleton as the first release, e.g. login, browse and checkout in an online shop.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'sophie.hoffmann@nordwest.edu', 1, 'Sprint Retrospective', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'sophie.hoffmann@nordwest.edu', 2, 'Yes', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'sophie.hoffmann@nordwest.edu', 3, 'Sprint Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'sophie.hoffmann@nordwest.edu', 4, 'Story maps are about drawing. I think they help the team.', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'tim.meier@nordwest.edu', 1, 'Daily Scrum', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'tim.meier@nordwest.edu', 2, 'No', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'tim.meier@nordwest.edu', 3, 'Product Backlog', NULL, FALSE),
  ('SE101', 'SE101 Midterm Examination', 'tim.meier@nordwest.edu', 4, 'User story mapping arranges stories along the user journey so the team can slice a walking skeleton as the first release, e.g. login, browse and checkout in an online shop.', NULL, FALSE)
) AS v(course_code, exam_title, student_email, q_position, response, awarded_marks, auto_marked)
JOIN public.courses c ON c.code = v.course_code
JOIN public.exams e ON e.course_id = c.id AND e.title = v.exam_title
JOIN auth.users u ON u.email = v.student_email
JOIN public.exam_attempts att ON att.exam_id = e.id AND att.student_id = u.id
JOIN public.exam_questions q ON q.exam_id = e.id AND q.position = v.q_position
ON CONFLICT (attempt_id, question_id) DO UPDATE SET
  response = EXCLUDED.response,
  awarded_marks = EXCLUDED.awarded_marks,
  auto_marked = EXCLUDED.auto_marked;

COMMIT;