-- Ensure pgcrypto extension is enabled for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

DO $$
DECLARE
  pwd_hash text := crypt('NordWest2026!', gen_salt('bf'));
  u_id uuid;
  
  -- Record structure for user provisioning
  users_data record;
BEGIN
  -- Temporary table of all university staff & students
  CREATE TEMP TABLE temp_seed_users (
    email text,
    full_name text,
    role text,
    student_number text,
    study_course text,
    semester_level integer
  ) ON COMMIT DROP;

  INSERT INTO temp_seed_users (email, full_name, role, student_number, study_course, semester_level) VALUES
    -- Faculty & Administration
    ('anna.mueller@nordwest.edu', 'Prof. Dr. Anna Müller', 'lecturer', NULL, NULL, NULL),
    ('registrar@nordwest.edu', 'NordWest Registrar', 'lecturer', NULL, NULL, NULL),

    -- Enrolled Students
    ('max.schneider@nordwest.edu', 'Max Schneider', 'student', '4250001', 'B.Sc. Computer Science', 3),
    ('lena.wagner@nordwest.edu', 'Lena Wagner', 'student', '4250002', 'B.Sc. Computer Science', 5),
    ('jonas.becker@nordwest.edu', 'Jonas Becker', 'student', '4250003', 'B.Sc. Data Science', 1),
    ('sophie.hoffmann@nordwest.edu', 'Sophie Hoffmann', 'student', '4250004', 'B.Sc. Business Administration', 1),
    ('felix.schulz@nordwest.edu', 'Felix Schulz', 'student', '4250005', 'B.Sc. Cyber Security', 5),
    ('mia.koch@nordwest.edu', 'Mia Koch', 'student', '4250006', 'B.Sc. Computer Science', 3),
    ('lukas.richter@nordwest.edu', 'Lukas Richter', 'student', '4250007', 'B.Sc. Data Science', 2),
    ('hannah.klein@nordwest.edu', 'Hannah Klein', 'student', '4250008', 'B.Sc. Business Administration', 2),
    ('paul.wolf@nordwest.edu', 'Paul Wolf', 'student', '4250009', 'B.Sc. Cyber Security', 2),
    ('emma.neumann@nordwest.edu', 'Emma Neumann', 'student', '4250010', 'B.Sc. Computer Science', 5),
    ('leon.schwarz@nordwest.edu', 'Leon Schwarz', 'student', '4250011', 'B.Sc. Data Science', 1),
    ('clara.zimmermann@nordwest.edu', 'Clara Zimmermann', 'student', '4250012', 'B.Sc. Business Administration', 5),
    ('noah.braun@nordwest.edu', 'Noah Braun', 'student', '4250013', 'B.Sc. Cyber Security', 5),
    ('lea.krueger@nordwest.edu', 'Lea Krüger', 'student', '4250014', 'B.Sc. Computer Science', 4),
    ('elias.hartmann@nordwest.edu', 'Elias Hartmann', 'student', '4250015', 'B.Sc. Data Science', 1),
    ('marie.lange@nordwest.edu', 'Marie Lange', 'student', '4250016', 'B.Sc. Business Administration', 4),
    ('finn.werner@nordwest.edu', 'Finn Werner', 'student', '4250017', 'B.Sc. Cyber Security', 3),
    ('laura.krause@nordwest.edu', 'Laura Krause', 'student', '4250018', 'B.Sc. Computer Science', 1),
    ('tim.meier@nordwest.edu', 'Tim Meier', 'student', '4250019', 'B.Sc. Data Science', 1),
    ('sarah.lehmann@nordwest.edu', 'Sarah Lehmann', 'student', '4250020', 'B.Sc. Business Administration', 1),
    ('david.koehler@nordwest.edu', 'David Köhler', 'student', '4250021', 'B.Sc. Cyber Security', 2),
    ('julia.huber@nordwest.edu', 'Julia Huber', 'student', '4250022', 'B.Sc. Computer Science', 2),
    ('niklas.kaiser@nordwest.edu', 'Niklas Kaiser', 'student', '4250023', 'B.Sc. Data Science', 4),
    ('amira.haddad@nordwest.edu', 'Amira Haddad', 'student', '4250024', 'B.Sc. Business Administration', 4),
    ('mehmet.yilmaz@nordwest.edu', 'Mehmet Yilmaz', 'student', '4250025', 'B.Sc. Cyber Security', 1),
    ('chiara.rossi@nordwest.edu', 'Chiara Rossi', 'student', '4250026', 'B.Sc. Computer Science', 4),
    ('ivan.petrov@nordwest.edu', 'Ivan Petrov', 'student', '4250027', 'B.Sc. Data Science', 2),
    ('yuki.tanaka@nordwest.edu', 'Yuki Tanaka', 'student', '4250028', 'B.Sc. Business Administration', 5),
    ('oliver.fischer@nordwest.edu', 'Oliver Fischer', 'student', '4250029', 'B.Sc. Cyber Security', 5),
    ('nora.berg@nordwest.edu', 'Nora Berg', 'student', '4250030', 'B.Sc. Computer Science', 5),
    ('emil.vogel@nordwest.edu', 'Emil Vogel', 'student', '4250031', 'B.Sc. Data Science', 4);

  -- Loop through and create/update auth.users, profiles, and roles
  FOR users_data IN SELECT * FROM temp_seed_users LOOP
    -- Check if user already exists
    SELECT id INTO u_id FROM auth.users WHERE email = users_data.email;

    IF u_id IS NULL THEN
      u_id := gen_random_uuid();
      
      INSERT INTO auth.users (
        id,
        instance_id,
        aud,
        role,
        email,
        encrypted_password,
        email_confirmed_at,
        raw_app_meta_data,
        raw_user_meta_data,
        created_at,
        updated_at
      ) VALUES (
        u_id,
        '00000000-0000-0000-0000-000000000000',
        'authenticated',
        'authenticated',
        users_data.email,
        pwd_hash,
        now(),
        '{"provider":"email","providers":["email"]}'::jsonb,
        jsonb_build_object(
          'full_name', users_data.full_name,
          'role', users_data.role,
          'student_number', users_data.student_number,
          'study_course', users_data.study_course,
          'semester_level', users_data.semester_level
        ),
        now(),
        now()
      );
    ELSE
      -- Update existing user's password and metadata
      UPDATE auth.users
      SET
        encrypted_password = pwd_hash,
        raw_user_meta_data = jsonb_build_object(
          'full_name', users_data.full_name,
          'role', users_data.role,
          'student_number', users_data.student_number,
          'study_course', users_data.study_course,
          'semester_level', users_data.semester_level
        ),
        updated_at = now()
      WHERE id = u_id;
    END IF;

    -- Ensure public profile is synchronized
    INSERT INTO public.profiles (id, full_name, student_number, study_course, semester_level)
    VALUES (
      u_id,
      users_data.full_name,
      users_data.student_number,
      users_data.study_course,
      users_data.semester_level
    )
    ON CONFLICT (id) DO UPDATE SET
      full_name = EXCLUDED.full_name,
      student_number = EXCLUDED.student_number,
      study_course = EXCLUDED.study_course,
      semester_level = EXCLUDED.semester_level;

    -- Ensure role assignment
    INSERT INTO public.user_roles (user_id, role)
    VALUES (u_id, users_data.role::public.app_role)
    ON CONFLICT (user_id, role) DO NOTHING;

  END LOOP;
END $$;
