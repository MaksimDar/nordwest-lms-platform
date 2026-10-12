-- Signup hardening: never trust a client-supplied role.
-- Before: raw_user_meta_data->>'role' = 'lecturer' made the new user a lecturer, and anyone can
-- call the public Supabase sign-up endpoint with arbitrary metadata.
-- After: every new account starts as a student. Lecturers are promoted by an administrator, e.g.
--   update public.user_roles set role = 'lecturer'
--    where user_id = (select id from auth.users where email = 'anna.mueller@nordwest.edu');
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = public AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, student_number, study_course, semester_level)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', NEW.raw_user_meta_data->>'name', split_part(NEW.email,'@',1)),
    NEW.raw_user_meta_data->>'student_number',
    NEW.raw_user_meta_data->>'study_course',
    NULLIF(NEW.raw_user_meta_data->>'semester_level','')::int
  )
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.user_roles (user_id, role) VALUES (NEW.id, 'student'::public.app_role) ON CONFLICT DO NOTHING;
  RETURN NEW;
END;
$$;
