-- Seed Data

-- Pathways
insert into public.pathways (title, description, tags) values
('Web Dev', 'Learn HTML, CSS, JS, and React.', '{"tech", "coding"}'),
('Data Analytics', 'Master SQL, Python, and PowerBI.', '{"data", "stats"}');

-- Steps
insert into public.pathway_steps (pathway_id, step_order, title, description) values
(1, 1, 'HTML Basics', 'Learn structure'),
(1, 2, 'CSS Basics', 'Learn styling');

-- Quiz Questions
insert into public.quiz_questions (id, question_text) values
(1, 'What is your primary interest?');

-- Quiz Options
insert into public.quiz_options (question_id, option_text, maps_to_pathway_id, weight) values
(1, 'Building websites', 1, 10),
(1, 'Analyzing data', 2, 10);
