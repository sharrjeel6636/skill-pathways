-- Seed Data: AI Skill Gap Analyzer - Required Roles and Skills
-- Note: This is a rule-based lookup/comparison, not a machine-learning model.

insert into public.role_skills (role_name, required_skills, recommended_order) values
('Software Engineer', 
 array['Python', 'SQL', 'Algorithms', 'System Design', 'Git'], 
 array['Python', 'SQL', 'Git', 'Algorithms', 'System Design']),
('Data Scientist', 
 array['Python', 'Pandas', 'SQL', 'Statistics', 'Machine Learning', 'Model Deployment'], 
 array['Python', 'SQL', 'Pandas', 'Statistics', 'Machine Learning', 'Model Deployment']),
('Electrical Engineer', 
 array['Circuit Analysis', 'Embedded Systems', 'Matlab', 'PCB Design', 'Python'], 
 array['Circuit Analysis', 'Matlab', 'PCB Design', 'Embedded Systems', 'Python']),
('Doctor', 
 array['Biology', 'Anatomy', 'Clinical Practice', 'Patient Care', 'Medical Research'], 
 array['Biology', 'Anatomy', 'Clinical Practice', 'Medical Research', 'Patient Care']),
('Accountant', 
 array['Accounting', 'Excel', 'Taxes', 'Auditing', 'Financial Modeling'], 
 array['Accounting', 'Excel', 'Auditing', 'Taxes', 'Financial Modeling']),
('Graphic Designer', 
 array['Adobe Suite', 'Typography', 'Color Theory', 'UI/UX Design', 'Branding'], 
 array['Color Theory', 'Typography', 'Adobe Suite', 'UI/UX Design', 'Branding']);
