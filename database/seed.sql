-- Seed Data: Pakistan-Focused Career Pathways
-- Run only on empty tables (or clear pathways-related data first)
insert into public.pathways (title, description, tags) values
('Pre-Engineering', 'Path toward engineering universities (NUST, UET, GIKI, FAST). Focus on Math, Physics, Chemistry.', array['engineering','math','physics','ecat']),
('Pre-Medical', 'Path toward MBBS/BDS and health sciences. Focus on Biology, Chemistry, Physics (MDCAT).', array['medical','biology','chemistry','mdcat']),
('Computer Science / IT', 'Path toward software engineering, IT, and tech careers in Pakistan.', array['tech','cs','coding','programming']);
-- Pre-Engineering (id 1 if fresh DB)
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(1, 1, 'Matric (Science Group)', 'Strong foundation in Physics, Chemistry, and Math.'),
(1, 2, 'Intermediate (FSc Pre-Engineering)', 'Focus on Calculus, Physics, and Chemistry.'),
(1, 3, 'Entry Test Prep (ECAT / NUST NET)', 'Prepare for engineering university entrance tests.'),
(1, 4, 'University Admissions', 'Apply to NUST, UET, GIKI, FAST and similar programs.'),
(1, 5, 'Skills & Internship', 'Build practical skills and complete internships.'),
(1, 6, 'Career Start', 'Job search, certifications, and professional growth.');
-- Pre-Medical (id 2)
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(2, 1, 'Matric (Science Group)', 'Strong foundation in Biology, Chemistry, and Physics.'),
(2, 2, 'Intermediate (FSc Pre-Medical)', 'Deep focus on Biology and Chemistry.'),
(2, 3, 'Entry Test Prep (MDCAT)', 'Prepare for medical college admission test.'),
(2, 4, 'Medical College Admissions', 'Apply to public and private medical colleges.'),
(2, 5, 'Clinical Exposure & Skills', 'Volunteer, observe clinical settings, build soft skills.'),
(2, 6, 'Career Path', 'MBBS/BDS pathway and specialization planning.');
-- CS / IT (id 3)
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(3, 1, 'Matric / Early Coding Interest', 'Build logic and basic computer skills.'),
(3, 2, 'Intermediate (University-ready group)', 'Keep CS/IT university options open.'),
(3, 3, 'Entry Tests & Portfolio Start', 'University tests + small coding projects.'),
(3, 4, 'University (CS / SE / IT)', 'Apply to FAST, NUST, COMSATS, PU and similar.'),
(3, 5, 'Skills, Projects & Internship', 'Programming, projects, internships.'),
(3, 6, 'Career Start', 'Junior developer / IT roles, freelancing, certifications.');
insert into public.quiz_questions (question_text) values
('Which subjects do you enjoy most?'),
('What kind of work sounds most exciting long-term?');
insert into public.quiz_options (question_id, option_text, maps_to_pathway_id, weight) values
(1, 'Mathematics and Physics', 1, 10),
(1, 'Biology and Chemistry', 2, 10),
(1, 'Computers and problem-solving', 3, 10),
(2, 'Designing machines / structures / systems', 1, 8),
(2, 'Helping people through healthcare', 2, 8),
(2, 'Building apps, websites, or software', 3, 8);
insert into public.learning_materials (title, type, duration, is_verified, pathway_tag, content_url) values
('ECAT Preparation Overview', 'article', '20 min', true, 'engineering', 'https://example.com/ecat-prep'),
('MDCAT Biology Focus Areas', 'article', '25 min', true, 'medical', 'https://example.com/mdcat-bio'),
('Intro to Programming (Python)', 'course', '3 hours', true, 'cs', 'https://example.com/python-basics'),
('Choosing Intermediate Subjects in Pakistan', 'article', '15 min', true, 'general', 'https://example.com/intermediate-guidance');
