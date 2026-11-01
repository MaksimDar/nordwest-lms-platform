INSERT INTO public.courses (
  lecturer_id,
  code,
  name,
  description,
  semester,
  credits,
  discipline,
  professor_name,
  max_seats,
  registration_open
)
VALUES
  -- Business Administration
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA101', 'Principles of Management', 'Planning, organising, leading and controlling in modern organisations.', 'Winter 2026/27', 5, 'Business', 'Prof. Dr. Claudia Richter', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA102', 'Financial Accounting', 'Bookkeeping, financial statements and IFRS fundamentals.', 'Winter 2026/27', 5, 'Business', 'Dr. Henrik Lang', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA201', 'Marketing Management', 'Market research, segmentation, the marketing mix and digital marketing.', 'Winter 2026/27', 5, 'Business', 'Prof. Dr. Claudia Richter', 35, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA202', 'Corporate Finance', 'Capital budgeting, cost of capital, valuation and financing decisions.', 'Winter 2026/27', 5, 'Business', 'Dr. Henrik Lang', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA203', 'Business Law', 'German and EU contract, commercial and company law essentials.', 'Winter 2026/27', 5, 'Business', 'Dr. Miriam Kraus', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA301', 'Strategic Management', 'Competitive strategy, corporate strategy and strategy implementation.', 'Winter 2026/27', 5, 'Business', 'Prof. Dr. Claudia Richter', 35, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'BA302', 'Entrepreneurship', 'Business model design, lean start-up and venture financing.', 'Winter 2026/27', 5, 'Business', 'Dr. Miriam Kraus', 30, true),

  -- Computer Science
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS101', 'Introduction to Programming', 'Foundations of programming in Python: variables, control flow, functions, data structures and debugging.', 'Winter 2026/27', 6, 'Computer Science', 'Prof. Dr. Anna Müller', 45, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS102', 'Object-Oriented Programming', 'Classes, inheritance, interfaces and design by contract using Java.', 'Winter 2026/27', 6, 'Computer Science', 'Prof. Dr. Anna Müller', 35, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS201', 'Algorithms and Data Structures', 'Sorting, searching, trees, graphs and complexity analysis with Big-O notation.', 'Winter 2026/27', 6, 'Computer Science', 'Prof. Dr. Anna Müller', 45, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS202', 'Operating Systems', 'Processes, threads, scheduling, memory management and file systems.', 'Winter 2026/27', 6, 'Computer Science', 'Prof. Dr. Thomas Weber', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS203', 'Computer Networks', 'The TCP/IP stack, routing, switching and network programming.', 'Winter 2026/27', 5, 'Computer Science', 'Prof. Dr. Thomas Weber', 35, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS301', 'Web Application Development', 'Modern full-stack web development with TypeScript, React and REST APIs.', 'Winter 2026/27', 6, 'Computer Science', 'Prof. Dr. Anna Müller', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS302', 'Database Systems', 'Relational modelling, SQL, normalisation, transactions and indexing.', 'Winter 2026/27', 6, 'Computer Science', 'Dr. Katrin Fuchs', 35, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CS303', 'Artificial Intelligence', 'Search, knowledge representation, planning and an introduction to machine learning.', 'Winter 2026/27', 6, 'Computer Science', 'Prof. Dr. Jan Hofmann', 12, true),

  -- Cyber Security
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CY101', 'Foundations of Cyber Security', 'Threat landscape, CIA triad, risk management and security controls.', 'Winter 2026/27', 5, 'Cyber Security', 'Prof. Dr. Stefan Brandt', 45, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CY201', 'Cryptography', 'Symmetric and asymmetric encryption, hashing, signatures and PKI.', 'Winter 2026/27', 5, 'Cyber Security', 'Prof. Dr. Stefan Brandt', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CY202', 'Network Security', 'Firewalls, IDS/IPS, VPNs and securing network protocols.', 'Winter 2026/27', 5, 'Cyber Security', 'Dr. Elena Vogt', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CY301', 'Ethical Hacking', 'Penetration testing methodology, reconnaissance, exploitation and reporting.', 'Winter 2026/27', 6, 'Cyber Security', 'Dr. Elena Vogt', 3, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'CY302', 'Security Operations and Forensics', 'SOC processes, incident response and digital forensics.', 'Winter 2026/27', 5, 'Cyber Security', 'Prof. Dr. Stefan Brandt', 35, true),

  -- Specialized Electives
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'DLCMSD2009', 'Crypto technologies', 'An introduction course that represents basics of crypto technologies', 'Summer 2027', 5, '', '', 40, true),

  -- Data Science
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'DS101', 'Introduction to Data Science', 'The data science lifecycle, data wrangling with pandas and exploratory analysis.', 'Winter 2026/27', 5, 'Data Science', 'Dr. Priya Nair', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'DS201', 'Machine Learning', 'Supervised and unsupervised learning, model evaluation and regularisation.', 'Winter 2026/27', 6, 'Data Science', 'Prof. Dr. Jan Hofmann', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'DS202', 'Data Visualisation', 'Visual perception, chart design and interactive dashboards.', 'Winter 2026/27', 5, 'Data Science', 'Dr. Priya Nair', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'DS301', 'Big Data Technologies', 'Distributed storage and processing with Spark, streaming and data lakes.', 'Winter 2026/27', 6, 'Data Science', 'Dr. Priya Nair', 45, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'DS302', 'Deep Learning', 'Neural networks, CNNs, transformers and practical training techniques.', 'Winter 2026/27', 6, 'Data Science', 'Prof. Dr. Jan Hofmann', 30, true),

  -- Economics & Information Systems
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'EC101', 'Microeconomics', 'Supply and demand, consumer and producer theory, market structures.', 'Winter 2026/27', 5, 'Economics', 'Dr. Henrik Lang', 45, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'IS201', 'Business Information Systems', 'ERP, CRM, process modelling and IT governance in enterprises.', 'Winter 2026/27', 5, 'Information Systems', 'Dr. Katrin Fuchs', 40, true),

  -- Mathematics
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'MA101', 'Linear Algebra', 'Vectors, matrices, linear maps, eigenvalues and applications.', 'Winter 2026/27', 5, 'Mathematics', 'Prof. Dr. Ingrid Sommer', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'MA102', 'Calculus I', 'Limits, derivatives, integrals and series for engineers and scientists.', 'Winter 2026/27', 5, 'Mathematics', 'Prof. Dr. Ingrid Sommer', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'MA201', 'Discrete Mathematics', 'Logic, sets, combinatorics, graph theory and proof techniques.', 'Winter 2026/27', 5, 'Mathematics', 'Dr. Martin Roth', 45, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'MA202', 'Probability and Statistics', 'Random variables, distributions, estimation and hypothesis testing.', 'Winter 2026/27', 5, 'Mathematics', 'Dr. Martin Roth', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'registrar@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'MA301', 'Numerical Methods', 'Root finding, interpolation, numerical integration and error analysis.', 'Winter 2026/27', 5, 'Mathematics', 'Prof. Dr. Ingrid Sommer', 40, true),

  -- Software Engineering
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'SE101', 'Agile Software Engineering', 'Scrum, Kanban, user stories, sprint planning and continuous delivery in practice.', 'Winter 2026/27', 5, 'Software Engineering', 'Prof. Dr. Anna Müller', 40, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'SE201', 'Software Architecture', 'Layered, event-driven and microservice architectures; quality attributes and trade-offs.', 'Winter 2026/27', 5, 'Software Engineering', 'Prof. Dr. Anna Müller', 30, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'SE202', 'Software Testing and Quality', 'Unit, integration and end-to-end testing, TDD and static analysis.', 'Winter 2026/27', 5, 'Software Engineering', 'Prof. Dr. Anna Müller', 35, true),
  (COALESCE((SELECT id FROM auth.users WHERE email = 'anna.mueller@nordwest.edu'), (SELECT id FROM auth.users LIMIT 1)), 'SE301', 'Requirements Engineering', 'Stakeholder analysis, elicitation techniques, use cases and requirements validation.', 'Winter 2026/27', 5, 'Software Engineering', 'Prof. Dr. Anna Müller', 45, true)
ON CONFLICT (code) DO UPDATE SET
  lecturer_id       = EXCLUDED.lecturer_id,
  name              = EXCLUDED.name,
  description       = EXCLUDED.description,
  semester          = EXCLUDED.semester,
  credits           = EXCLUDED.credits,
  discipline        = EXCLUDED.discipline,
  professor_name    = EXCLUDED.professor_name,
  max_seats         = EXCLUDED.max_seats,
  registration_open = EXCLUDED.registration_open;

