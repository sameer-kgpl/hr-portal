-- Recruitment Portal Seed Data
USE recruitment_portal;

-- Seed roles
INSERT INTO roles (name, description)
VALUES 
  ('admin', 'Administrative user with full access'),
  ('recruiter', 'Recruiter user with search and management capabilities'),
  ('candidate', 'Candidate user with ability to manage own profile')
ON DUPLICATE KEY UPDATE description = VALUES(description);

-- Seed users (password hashes will be updated by backend seed script)
INSERT INTO users (full_name, email, phone, password_hash, role_id, is_active)
VALUES
  ('System Admin', 'admin@example.com', '+91-9000000001', 'TO_BE_SET_BY_SETUP', (SELECT id FROM roles WHERE name = 'admin'), 1),
  ('Default Recruiter', 'recruiter@example.com', '+91-9000000002', 'TO_BE_SET_BY_SETUP', (SELECT id FROM roles WHERE name = 'recruiter'), 1),
  ('Sample Candidate', 'candidate@example.com', '+91-9000000003', 'TO_BE_SET_BY_SETUP', (SELECT id FROM roles WHERE name = 'candidate'), 1)
ON DUPLICATE KEY UPDATE phone = VALUES(phone);

-- Seed 50 candidates with varied skills, locations, experiences, and notice periods
INSERT INTO candidates (
  full_name, email, phone, current_location, preferred_location,
  total_experience_years, notice_period, availability_date, skills_json, skills_flat,
  last_updated, generic_notes
) VALUES
  ('Aarav Sharma', 'aarav.sharma@example.com', '+91-9810000001', 'Bengaluru', 'Bengaluru', 6.0, '30 days', NULL, JSON_ARRAY('Java', 'Spring', 'Microservices', 'MySQL'), 'java,spring,microservices,mysql', DATE_SUB(NOW(), INTERVAL 5 DAY), 'Backend engineer'),
  ('Priya Nair', 'priya.nair@example.com', '+91-9810000002', 'Hyderabad', 'Bengaluru', 4.5, '15 days', NULL, JSON_ARRAY('JavaScript', 'React', 'Node.js', 'Express'), 'javascript,react,node.js,express', DATE_SUB(NOW(), INTERVAL 12 DAY), 'Full-stack dev'),
  ('Rahul Verma', 'rahul.verma@example.com', '+91-9810000003', 'Pune', 'Pune', 8.0, 'Immediate', NULL, JSON_ARRAY('Python', 'Django', 'REST', 'PostgreSQL'), 'python,django,rest,postgresql', DATE_SUB(NOW(), INTERVAL 2 DAY), 'Python backend'),
  ('Sneha Gupta', 'sneha.gupta@example.com', '+91-9810000004', 'Chennai', 'Bengaluru', 3.0, '30 days', NULL, JSON_ARRAY('QA', 'Selenium', 'TestNG', 'API Testing'), 'qa,selenium,testng,api testing', DATE_SUB(NOW(), INTERVAL 20 DAY), 'QA engineer'),
  ('Vikram Iyer', 'vikram.iyer@example.com', '+91-9810000005', 'Mumbai', 'Mumbai', 10.0, '15 days', NULL, JSON_ARRAY('AWS', 'Docker', 'Kubernetes', 'Terraform'), 'aws,docker,kubernetes,terraform', DATE_SUB(NOW(), INTERVAL 30 DAY), 'DevOps lead'),
  ('Aisha Khan', 'aisha.khan@example.com', '+91-9810000006', 'Delhi NCR', 'Noida', 2.0, 'Immediate', NULL, JSON_ARRAY('HTML', 'CSS', 'JavaScript', 'Bootstrap'), 'html,css,javascript,bootstrap', DATE_SUB(NOW(), INTERVAL 1 DAY), 'Frontend dev'),
  ('Manish Patel', 'manish.patel@example.com', '+91-9810000007', 'Bengaluru', 'Hyderabad', 7.5, '30 days', NULL, JSON_ARRAY('Java', 'Spring Boot', 'Hibernate', 'Oracle'), 'java,spring boot,hibernate,oracle', DATE_SUB(NOW(), INTERVAL 18 DAY), 'Senior Java dev'),
  ('Divya Menon', 'divya.menon@example.com', '+91-9810000008', 'Hyderabad', 'Chennai', 5.0, '15 days', NULL, JSON_ARRAY('Angular', 'TypeScript', 'RxJS', 'NgRx'), 'angular,typescript,rxjs,ngrx', DATE_SUB(NOW(), INTERVAL 40 DAY), 'Angular dev'),
  ('Karan Singh', 'karan.singh@example.com', '+91-9810000009', 'Pune', 'Pune', 1.5, 'Immediate', NULL, JSON_ARRAY('Python', 'Flask', 'SQLAlchemy'), 'python,flask,sqlalchemy', DATE_SUB(NOW(), INTERVAL 3 DAY), 'Junior Python dev'),
  ('Neha Joshi', 'neha.joshi@example.com', '+91-9810000010', 'Chennai', 'Bengaluru', 9.0, '30 days', NULL, JSON_ARRAY('Data Engineering', 'Spark', 'Hadoop', 'Airflow'), 'data engineering,spark,hadoop,airflow', DATE_SUB(NOW(), INTERVAL 11 DAY), 'Data engineer'),
  ('Arjun Rao', 'arjun.rao@example.com', '+91-9810000011', 'Mumbai', 'Pune', 6.5, '15 days', NULL, JSON_ARRAY('Golang', 'Microservices', 'GRPC', 'MySQL'), 'golang,microservices,grpc,mysql', DATE_SUB(NOW(), INTERVAL 8 DAY), 'Go backend'),
  ('Riya Desai', 'riya.desai@example.com', '+91-9810000012', 'Delhi NCR', 'Gurugram', 4.0, 'Immediate', NULL, JSON_ARRAY('Product Management', 'Agile', 'JIRA'), 'product management,agile,jira', DATE_SUB(NOW(), INTERVAL 6 DAY), 'PM'),
  ('Sameer Kulkarni', 'sameer.kulkarni@example.com', '+91-9810000013', 'Bengaluru', 'Bengaluru', 11.0, '30 days', NULL, JSON_ARRAY('C#', '.NET Core', 'Azure', 'SQL Server'), 'c#,.net core,azure,sql server', DATE_SUB(NOW(), INTERVAL 22 DAY), 'Microsoft stack'),
  ('Meera Pillai', 'meera.pillai@example.com', '+91-9810000014', 'Hyderabad', 'Hyderabad', 2.5, '15 days', NULL, JSON_ARRAY('UI/UX', 'Figma', 'Prototyping'), 'ui/ux,figma,prototyping', DATE_SUB(NOW(), INTERVAL 15 DAY), 'Designer'),
  ('Rohit Sinha', 'rohit.sinha@example.com', '+91-9810000015', 'Pune', 'Mumbai', 7.0, 'Immediate', NULL, JSON_ARRAY('Android', 'Kotlin', 'MVVM', 'REST'), 'android,kotlin,mvvm,rest', DATE_SUB(NOW(), INTERVAL 9 DAY), 'Android dev'),
  ('Ananya Das', 'ananya.das@example.com', '+91-9810000016', 'Chennai', 'Chennai', 3.5, '30 days', NULL, JSON_ARRAY('iOS', 'Swift', 'SwiftUI'), 'ios,swift,swiftui', DATE_SUB(NOW(), INTERVAL 27 DAY), 'iOS dev'),
  ('Harsh Vardhan', 'harsh.vardhan@example.com', '+91-9810000017', 'Mumbai', 'Bengaluru', 12.0, '15 days', NULL, JSON_ARRAY('Architect', 'Distributed Systems', 'AWS'), 'architect,distributed systems,aws', DATE_SUB(NOW(), INTERVAL 50 DAY), 'Software architect'),
  ('Kavya Reddy', 'kavya.reddy@example.com', '+91-9810000018', 'Delhi NCR', 'Noida', 1.0, 'Immediate', NULL, JSON_ARRAY('Manual Testing', 'JIRA'), 'manual testing,jira', DATE_SUB(NOW(), INTERVAL 4 DAY), 'QA'),
  ('Yash Mehta', 'yash.mehta@example.com', '+91-9810000019', 'Bengaluru', 'Pune', 5.5, '30 days', NULL, JSON_ARRAY('Node.js', 'Express', 'MongoDB', 'Redis'), 'node.js,express,mongodb,redis', DATE_SUB(NOW(), INTERVAL 16 DAY), 'Node dev'),
  ('Pooja Kaur', 'pooja.kaur@example.com', '+91-9810000020', 'Hyderabad', 'Bengaluru', 2.2, '15 days', NULL, JSON_ARRAY('React', 'Redux', 'TypeScript'), 'react,redux,typescript', DATE_SUB(NOW(), INTERVAL 7 DAY), 'Frontend'),
  ('Aditya Jain', 'aditya.jain@example.com', '+91-9810000021', 'Pune', 'Pune', 9.5, 'Immediate', NULL, JSON_ARRAY('Java', 'Kafka', 'Microservices', 'ELK'), 'java,kafka,microservices,elk', DATE_SUB(NOW(), INTERVAL 13 DAY), 'Senior backend'),
  ('Ishita Bose', 'ishita.bose@example.com', '+91-9810000022', 'Chennai', 'Hyderabad', 6.8, '30 days', NULL, JSON_ARRAY('Data Science', 'Pandas', 'scikit-learn', 'NLP'), 'data science,pandas,scikit-learn,nlp', DATE_SUB(NOW(), INTERVAL 25 DAY), 'Data scientist'),
  ('Nikhil Arora', 'nikhil.arora@example.com', '+91-9810000023', 'Mumbai', 'Mumbai', 4.7, '15 days', NULL, JSON_ARRAY('DevOps', 'CI/CD', 'Jenkins', 'Docker'), 'devops,ci/cd,jenkins,docker', DATE_SUB(NOW(), INTERVAL 19 DAY), 'DevOps engineer'),
  ('Sara Thomas', 'sara.thomas@example.com', '+91-9810000024', 'Delhi NCR', 'Gurugram', 3.1, 'Immediate', NULL, JSON_ARRAY('HR', 'Recruitment', 'ATS'), 'hr,recruitment,ats', DATE_SUB(NOW(), INTERVAL 14 DAY), 'HR'),
  ('Rakesh Bhat', 'rakesh.bhat@example.com', '+91-9810000025', 'Bengaluru', 'Chennai', 8.3, '30 days', NULL, JSON_ARRAY('C++', 'Linux', 'Multithreading'), 'c++,linux,multithreading', DATE_SUB(NOW(), INTERVAL 33 DAY), 'Systems dev'),
  ('Shreya Kulkarni', 'shreya.kulkarni@example.com', '+91-9810000026', 'Hyderabad', 'Hyderabad', 2.8, '15 days', NULL, JSON_ARRAY('Vue.js', 'Vuex', 'Nuxt'), 'vue.js,vuex,nuxt', DATE_SUB(NOW(), INTERVAL 10 DAY), 'Frontend'),
  ('Abhinav Mishra', 'abhinav.mishra@example.com', '+91-9810000027', 'Pune', 'Mumbai', 6.2, 'Immediate', NULL, JSON_ARRAY('Salesforce', 'Apex', 'LWC'), 'salesforce,apex,lwc', DATE_SUB(NOW(), INTERVAL 21 DAY), 'SFDC dev'),
  ('Tanya Kapoor', 'tanya.kapoor@example.com', '+91-9810000028', 'Chennai', 'Bengaluru', 1.7, '30 days', NULL, JSON_ARRAY('Content Writing', 'SEO'), 'content writing,seo', DATE_SUB(NOW(), INTERVAL 17 DAY), 'Content'),
  ('Sandeep Reddy', 'sandeep.reddy@example.com', '+91-9810000029', 'Mumbai', 'Pune', 7.9, '15 days', NULL, JSON_ARRAY('PHP', 'Laravel', 'MySQL'), 'php,laravel,mysql', DATE_SUB(NOW(), INTERVAL 23 DAY), 'Backend PHP'),
  ('Ritu Singh', 'ritu.singh@example.com', '+91-9810000030', 'Delhi NCR', 'Noida', 5.3, 'Immediate', NULL, JSON_ARRAY('Angular', 'Node.js', 'MySQL'), 'angular,node.js,mysql', DATE_SUB(NOW(), INTERVAL 29 DAY), 'Full-stack'),
  ('Zaid Ali', 'zaid.ali@example.com', '+91-9810000031', 'Bengaluru', 'Bengaluru', 0.8, '30 days', NULL, JSON_ARRAY('HTML', 'CSS', 'JavaScript'), 'html,css,javascript', DATE_SUB(NOW(), INTERVAL 31 DAY), 'Fresher'),
  ('Leela Krishnan', 'leela.krishnan@example.com', '+91-9810000032', 'Hyderabad', 'Chennai', 4.1, '15 days', NULL, JSON_ARRAY('Python', 'Pandas', 'SQL'), 'python,pandas,sql', DATE_SUB(NOW(), INTERVAL 35 DAY), 'Data analyst'),
  ('Mohit Jain', 'mohit.jain@example.com', '+91-9810000033', 'Pune', 'Pune', 3.9, 'Immediate', NULL, JSON_ARRAY('React Native', 'React', 'Redux'), 'react native,react,redux', DATE_SUB(NOW(), INTERVAL 28 DAY), 'Mobile dev'),
  ('Aditi Rao', 'aditi.rao@example.com', '+91-9810000034', 'Chennai', 'Hyderabad', 9.2, '30 days', NULL, JSON_ARRAY('Security', 'Penetration Testing', 'OWASP'), 'security,penetration testing,owasp', DATE_SUB(NOW(), INTERVAL 41 DAY), 'Security eng'),
  ('Farhan Siddiqui', 'farhan.siddiqui@example.com', '+91-9810000035', 'Mumbai', 'Mumbai', 6.7, '15 days', NULL, JSON_ARRAY('BigQuery', 'GCP', 'ETL'), 'bigquery,gcp,etl', DATE_SUB(NOW(), INTERVAL 26 DAY), 'Data engineer'),
  ('Sunita Yadav', 'sunita.yadav@example.com', '+91-9810000036', 'Delhi NCR', 'Gurugram', 2.4, 'Immediate', NULL, JSON_ARRAY('Customer Support', 'Zendesk'), 'customer support,zendesk', DATE_SUB(NOW(), INTERVAL 37 DAY), 'Support'),
  ('Tarun Malhotra', 'tarun.malhotra@example.com', '+91-9810000037', 'Bengaluru', 'Hyderabad', 8.9, '30 days', NULL, JSON_ARRAY('Scala', 'Spark', 'Kafka'), 'scala,spark,kafka', DATE_SUB(NOW(), INTERVAL 45 DAY), 'Data platform'),
  ('Naina Mehta', 'naina.mehta@example.com', '+91-9810000038', 'Hyderabad', 'Bengaluru', 5.8, '15 days', NULL, JSON_ARRAY('QA Automation', 'Cypress', 'Playwright'), 'qa automation,cypress,playwright', DATE_SUB(NOW(), INTERVAL 24 DAY), 'QA'),
  ('Deepak Kumar', 'deepak.kumar@example.com', '+91-9810000039', 'Pune', 'Chennai', 7.4, 'Immediate', NULL, JSON_ARRAY('Ruby', 'Rails', 'PostgreSQL'), 'ruby,rails,postgresql', DATE_SUB(NOW(), INTERVAL 12 DAY), 'Ruby dev'),
  ('Bhavana Shetty', 'bhavana.shetty@example.com', '+91-9810000040', 'Chennai', 'Chennai', 1.2, '30 days', NULL, JSON_ARRAY('Marketing', 'Google Ads'), 'marketing,google ads', DATE_SUB(NOW(), INTERVAL 48 DAY), 'Marketing'),
  ('Parth Trivedi', 'parth.trivedi@example.com', '+91-9810000041', 'Mumbai', 'Pune', 6.1, '15 days', NULL, JSON_ARRAY('Elixir', 'Phoenix', 'PostgreSQL'), 'elixir,phoenix,postgresql', DATE_SUB(NOW(), INTERVAL 32 DAY), 'Backend'),
  ('Radhika Kapoor', 'radhika.kapoor@example.com', '+91-9810000042', 'Delhi NCR', 'Noida', 3.6, 'Immediate', NULL, JSON_ARRAY('Business Analysis', 'SQL', 'User Stories'), 'business analysis,sql,user stories', DATE_SUB(NOW(), INTERVAL 38 DAY), 'BA'),
  ('Suhas Hegde', 'suhas.hegde@example.com', '+91-9810000043', 'Bengaluru', 'Bengaluru', 10.5, '30 days', NULL, JSON_ARRAY('Project Management', 'Scrum', 'Kanban'), 'project management,scrum,kanban', DATE_SUB(NOW(), INTERVAL 20 DAY), 'PM'),
  ('Heena Khan', 'heena.khan@example.com', '+91-9810000044', 'Hyderabad', 'Hyderabad', 4.3, '15 days', NULL, JSON_ARRAY('Python', 'FastAPI', 'RabbitMQ'), 'python,fastapi,rabbitmq', DATE_SUB(NOW(), INTERVAL 34 DAY), 'Backend'),
  ('Gaurav Bansal', 'gaurav.bansal@example.com', '+91-9810000045', 'Pune', 'Pune', 2.9, 'Immediate', NULL, JSON_ARRAY('Test Automation', 'Selenium', 'Python'), 'test automation,selenium,python', DATE_SUB(NOW(), INTERVAL 36 DAY), 'QA'),
  ('Nikita Jain', 'nikita.jain@example.com', '+91-9810000046', 'Chennai', 'Bengaluru', 6.9, '30 days', NULL, JSON_ARRAY('React', 'Next.js', 'TypeScript'), 'react,next.js,typescript', DATE_SUB(NOW(), INTERVAL 42 DAY), 'Frontend'),
  ('Uday Kiran', 'uday.kiran@example.com', '+91-9810000047', 'Mumbai', 'Mumbai', 5.1, '15 days', NULL, JSON_ARRAY('Android', 'Java', 'Retrofit'), 'android,java,retrofit', DATE_SUB(NOW(), INTERVAL 44 DAY), 'Android'),
  ('Asmita Ghosh', 'asmita.ghosh@example.com', '+91-9810000048', 'Delhi NCR', 'Noida', 3.3, 'Immediate', NULL, JSON_ARRAY('Data Visualization', 'Tableau', 'Power BI'), 'data visualization,tableau,power bi', DATE_SUB(NOW(), INTERVAL 39 DAY), 'BI'),
  ('Vivek Tiwari', 'vivek.tiwari@example.com', '+91-9810000049', 'Bengaluru', 'Chennai', 7.2, '30 days', NULL, JSON_ARRAY('Kotlin', 'Spring', 'MySQL'), 'kotlin,spring,mysql', DATE_SUB(NOW(), INTERVAL 46 DAY), 'Backend'),
  ('Pallavi Deshmukh', 'pallavi.deshmukh@example.com', '+91-9810000050', 'Hyderabad', 'Pune', 4.6, '15 days', NULL, JSON_ARRAY('PHP', 'Symfony', 'MySQL'), 'php,symfony,mysql', DATE_SUB(NOW(), INTERVAL 43 DAY), 'Backend');