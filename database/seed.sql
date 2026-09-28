-- Seed Data: Pakistan-Focused Career Pathways & Educational Resources
-- Run on database initialization or reset

-- Pathways
insert into public.pathways (title, description, tags) values
('Pre-Engineering', 'Path toward engineering universities (NUST, UET, GIKI, FAST). Focus on Math, Physics, Chemistry.', array['engineering','math','physics','ecat']),
('Pre-Medical', 'Path toward MBBS/BDS and health sciences. Focus on Biology, Chemistry, Physics (MDCAT).', array['medical','biology','chemistry','mdcat']),
('Computer Science / IT', 'Path toward software engineering, IT, and tech careers in Pakistan.', array['tech','cs','coding','programming']),
('Business/Commerce', 'Path toward BBA, BS Accounting and Finance, CA/ACCA pathways.', array['business','commerce','finance','accounting']),
('Arts & Design', 'Path toward graphic design, fine arts, architecture, and media studies.', array['arts','design','media','architecture']),
('Vocational/TEVTA', 'Technical and vocational training for immediate employability.', array['vocational','technical','skills','tevta']);

-- Steps for all pathways
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(1, 1, 'Matric (Science Group)', 'Strong foundation in Physics, Chemistry, and Math.'),
(1, 2, 'Intermediate (FSc Pre-Engineering)', 'Focus on Calculus, Physics, and Chemistry.'),
(1, 3, 'Entry Test Prep (ECAT / NUST NET)', 'Prepare for engineering university entrance tests.'),
(1, 4, 'University Admissions & Degree', 'Enroll in BE / BS Engineering program.'),
(2, 1, 'Matric (Science Group)', 'Strong foundation in Biology, Chemistry, and Physics.'),
(2, 2, 'Intermediate (FSc Pre-Medical)', 'Deep focus on Biology and Chemistry.'),
(2, 3, 'Entry Test Prep (MDCAT)', 'Prepare for medical college admission test (MBBS/BDS).'),
(2, 4, 'Medical College Admission', 'Secure admission in public or private medical college.'),
(3, 1, 'Matric / Early Coding Interest', 'Build logic, mathematics, and basic computer literacy.'),
(3, 2, 'Intermediate (ICS / Pre-Engineering)', 'Keep CS/IT university options open with math background.'),
(3, 3, 'Entry Tests & Portfolio Start', 'University tests (FAST, NUST, FAST-NUCES) + coding projects.'),
(3, 4, 'BS Computer Science & Internships', 'Build software engineering foundations and GitHub portfolio.'),
(4, 1, 'Matric (Science or Arts/Commerce)', 'General foundation with strong numerical aptitude.'),
(4, 2, 'Intermediate (I.Com / FSC / A-Levels)', 'Focus on Accounting, Economics, or Mathematics.'),
(4, 3, 'Business Admission Tests (IBA / LUMS / LSE)', 'Prepare for entry tests and interviews for top business schools.'),
(4, 4, 'BBA / BS Accounting & Professional Certs', 'Pursue degree alongside ACCA/CA foundations.'),
(5, 1, 'Matric (Any Group)', 'Develop foundational sketching and visual awareness.'),
(5, 2, 'Intermediate (FA / FSc / ICS)', 'Build creative portfolio and design basics.'),
(5, 3, 'NCA / Indus Valley / Beaconhouse Entry Tests', 'Aptitude test, drawing test, and portfolio review.'),
(5, 4, 'Bachelor of Architecture / Fine Arts', 'Complete design degree and build professional showcase.'),
(6, 1, 'Matric / Middle School', 'Identify technical trade or vocational interest.'),
(6, 2, 'TEVTA / NAVTTC Certified Technical Diploma', 'Hands-on training in electronics, welding, IT support, or drafting.'),
(6, 3, 'Apprenticeship & Certification', 'Gain practical work experience and industry certification.'),
(6, 4, 'Skilled Employment / Entrepreneurship', 'Enter workforce or start independent technical services.');

-- Universities
insert into public.universities (name, city, province, description, website_url) values
('National University of Sciences and Technology (NUST)', 'Islamabad', 'ICT', 'Top-tier public research university renowned for engineering and IT programs.', 'https://nust.edu.pk/'),
('Lahore University of Management Sciences (LUMS)', 'Lahore', 'Punjab', 'Leading private university for business, science, and humanities.', 'https://lums.edu.pk/'),
('Institute of Business Administration (IBA)', 'Karachi', 'Sindh', 'Premier business and management institution in Pakistan.', 'https://www.iba.edu.pk/'),
('University of Engineering and Technology (UET)', 'Lahore', 'Punjab', 'Historic public institution for engineering and technical education in Punjab.', 'https://uet.edu.pk/'),
('Aga Khan University (AKU)', 'Karachi', 'Sindh', 'Internationally recognized health sciences university and hospital.', 'https://www.aku.edu/'),
('FAST-NUCES', 'Islamabad / Lahore / Karachi', 'Multiple', 'Pioneering institution for computer science and software engineering.', 'https://www.nu.edu.pk/'),
('Ghulam Ishaq Khan Institute (GIKI)', 'Swabi', 'Khyber Pakhtunkhwa', 'Residential engineering institute with strong technical curriculum.', 'https://giki.edu.pk/'),
('Pakistan Institute of Engineering and Applied Sciences (PIEAS)', 'Islamabad', 'ICT', 'Top public engineering and nuclear sciences university.', 'https://www.pieas.edu.pk/'),
('NED University of Engineering & Technology', 'Karachi', 'Sindh', 'Established public engineering university in Sindh.', 'https://www.neduet.edu.pk/'),
('University of Peshawar', 'Peshawar', 'Khyber Pakhtunkhwa', 'Comprehensive public university offering diverse academic disciplines.', 'https://uop.edu.pk/');

-- Scholarships
insert into public.scholarships (title, provider, description, eligibility_criteria, deadline, website_url) values
('HEC Need-Based Scholarship', 'Higher Education Commission (HEC)', 'Financial assistance for undergraduate students enrolled in partner public and private universities.', 'Demonstrated financial need, Pakistani nationality, enrolled in undergraduate degree.', '2026-12-31', 'https://www.hec.gov.pk/'),
('Punjab Education Endowment Fund (PEEF)', 'PEEF Punjab', 'Merit-based scholarships for talented and financially constrained students in Punjab.', 'Academic excellence in Matric/Inter, Punjab domicile, family income below threshold.', '2026-11-30', 'https://www.peef.org.pk/'),
('USAID Merit and Needs-Based Scholarship', 'USAID / HEC', 'Full tuition and living stipend scholarship for undergraduate programs at partner universities.', 'Financial need and academic merit, open to Pakistani citizens for selected fields.', '2026-10-15', 'https://www.hec.gov.pk/'),
('Ehsaas Undergraduate Scholarship Project', 'Government of Pakistan', 'Major scholarship initiative covering tuition fee and living allowance for low-income households.', 'Admitted to undergraduate program in public sector university, family income criteria.', '2026-12-15', 'https://www.hec.gov.pk/'),
('National ICT R&D Fund Scholarship', 'Ministry of IT & Telecom', 'Scholarships for students pursuing ICT-related undergraduate degrees in accredited universities.', 'Enrolled in BS CS/IT/Software Engineering in approved institutions.', '2026-09-30', 'https://www.ictrdf.org.pk/');

-- Quiz Questions
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
('ECAT & NUST NET Preparation Guide', 'article', '25 min', true, 'engineering', 'https://www.nust.edu.pk/admissions/undergraduate/entry-test/'),
('MDCAT Biology & Chemistry Study Blueprint', 'article', '30 min', true, 'medical', 'https://www.pmc.gov.pk/'),
('Python for Beginners (freeCodeCamp)', 'course', '3 hours', true, 'cs', 'https://www.freecodecamp.org/learn/scientific-computing-with-python/python-for-everybody/'),
('HEC Digital Library & Student Resources', 'article', '15 min', true, 'general', 'https://www.hec.gov.pk/'),
('Guide to Choosing Intermediate Subjects in Pakistan', 'article', '20 min', true, 'general', 'https://www.bisefsd.edu.pk/'),
('ACCA & CA Foundations in Pakistan', 'article', '25 min', true, 'business', 'https://www.accaglobal.com/'),
('Building a Creative Design Portfolio', 'article', '30 min', true, 'arts', 'https://www.behance.net/');
