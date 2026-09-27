-- Seed Data: Pakistan-Focused Career Pathways
-- Run only on empty tables (or clear pathways-related data first)

-- Pathways
insert into public.pathways (title, description, tags) values
('Pre-Engineering', 'Path toward engineering universities (NUST, UET, GIKI, FAST). Focus on Math, Physics, Chemistry.', array['engineering','math','physics','ecat']),
('Pre-Medical', 'Path toward MBBS/BDS and health sciences. Focus on Biology, Chemistry, Physics (MDCAT).', array['medical','biology','chemistry','mdcat']),
('Computer Science / IT', 'Path toward software engineering, IT, and tech careers in Pakistan.', array['tech','cs','coding','programming']),
('Business/Commerce', 'Path toward BBA, BS Accounting and Finance, CA/ACCA pathways.', array['business','commerce','finance','accounting']),
('Arts & Design', 'Path toward graphic design, fine arts, architecture, and media studies.', array['arts','design','media','architecture']),
('Vocational/TEVTA', 'Technical and vocational training for immediate employability.', array['vocational','technical','skills','tevta']);

-- Steps (Simplified seeding for pathways)
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(1, 1, 'Matric (Science Group)', 'Strong foundation in Physics, Chemistry, and Math.'),
(1, 2, 'Intermediate (FSc Pre-Engineering)', 'Focus on Calculus, Physics, and Chemistry.'),
(1, 3, 'Entry Test Prep (ECAT / NUST NET)', 'Prepare for engineering university entrance tests.'),
(2, 1, 'Matric (Science Group)', 'Strong foundation in Biology, Chemistry, and Physics.'),
(2, 2, 'Intermediate (FSc Pre-Medical)', 'Deep focus on Biology and Chemistry.'),
(2, 3, 'Entry Test Prep (MDCAT)', 'Prepare for medical college admission test.'),
(3, 1, 'Matric / Early Coding Interest', 'Build logic and basic computer skills.'),
(3, 2, 'Intermediate (University-ready group)', 'Keep CS/IT university options open.'),
(3, 3, 'Entry Tests & Portfolio Start', 'University tests + small coding projects.');

-- Universities
insert into public.universities (name, city, province, description, website_url) values
('National University of Sciences and Technology (NUST)', 'Islamabad', 'ICT', 'Top-tier research university in Pakistan.', 'https://nust.edu.pk/'),
('University of Engineering and Technology (UET)', 'Lahore', 'Punjab', 'Premier institution for engineering in Punjab.', 'https://uet.edu.pk/'),
('NED University of Engineering & Technology', 'Karachi', 'Sindh', 'Leading engineering university in Sindh.', 'https://www.neduet.edu.pk/'),
('Institute of Business Administration (IBA)', 'Karachi', 'Sindh', 'Leading business school in Pakistan.', 'https://www.iba.edu.pk/');

-- Scholarships
insert into public.scholarships (title, provider, description, eligibility_criteria, deadline, website_url) values
('HEC Need-Based Scholarship', 'HEC', 'Need-based financial aid for undergraduate students.', 'Financial need, enrolled in public sector university.', '2026-12-31', 'https://www.hec.gov.pk/'),
('Punjab Education Endowment Fund (PEEF)', 'PEEF', 'Merit-based scholarships for high achievers in Punjab.', 'Academic excellence, Punjab domicile.', '2026-11-30', 'https://www.peef.org.pk/');

-- Quiz
insert into public.quiz_questions (question_text) values
('Which subjects do you enjoy most?'),
('What kind of work sounds most exciting long-term?');

insert into public.quiz_options (question_id, option_text, maps_to_pathway_id, weight) values
(1, 'Mathematics and Physics', 1, 10),
(1, 'Biology and Chemistry', 2, 10),
(1, 'Computers and problem-solving', 3, 10),
(1, 'Business and Finance', 4, 10),
(1, 'Creative Arts and Design', 5, 10),
(2, 'Designing machines / structures / systems', 1, 8),
(2, 'Helping people through healthcare', 2, 8),
(2, 'Building apps, websites, or software', 3, 8),
(2, 'Managing businesses and finances', 4, 8),
(2, 'Creative visualization and fine arts', 5, 8);

-- Learning Materials
insert into public.learning_materials (title, type, duration, is_verified, pathway_tag, content_url) values
('ECAT Preparation Overview', 'article', '20 min', true, 'engineering', 'https://www.nust.edu.pk/admissions/undergraduate/entry-test/'),
('MDCAT Biology Focus Areas', 'article', '25 min', true, 'medical', 'https://www.pmc.gov.pk/'),
('Intro to Programming (Python)', 'course', '3 hours', true, 'cs', 'https://www.freecodecamp.org/learn/scientific-computing-with-python/python-for-everybody/'),
('Choosing Intermediate Subjects in Pakistan', 'article', '15 min', true, 'general', 'https://www.bisefsd.edu.pk/');
