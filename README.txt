LAB 10 — MYSQL + SQL: UNIVERSITY RELATIONAL DATABASE
=====================================================

FILES
database/schema.sql       Creates database, six relational tables and seed data.
reports/queries.sql       Contains 21 SQL examples (including JOINs and aggregates).
README.txt                Setup guide, relationships, constraints and normalization notes.

REQUIREMENTS
- MySQL 8.0+ (recommended)
- XAMPP with MySQL and Apache, or another MySQL installation
- phpMyAdmin

HOW TO RUN IN XAMPP / PHPMYADMIN
1. Open XAMPP Control Panel.
2. Start MySQL. Apache can also be started to access phpMyAdmin.
3. Open http://localhost/phpmyadmin/
4. Select the Import tab.
5. Choose database/schema.sql from this project.
6. Click Import / Go. The script creates university_db and its tables.
7. To run the report queries, open university_db, select the SQL tab,
   paste reports/queries.sql, and click Go. You can also import that file.
8. View tables in the left sidebar: departments, students, teachers,
   courses, enrollments and attendance.

RELATIONSHIPS
- departments 1-to-many students: students.department_id references departments.
- departments 1-to-many teachers: teachers.department_id references departments.
- departments 1-to-many courses: courses.department_id references departments.
- teachers 1-to-many courses: courses.teacher_id references teachers.
- students many-to-many courses: enrollments is the junction table.
- enrollments 1-to-many attendance: attendance.enrollment_id references enrollments.

KEYS AND CONSTRAINTS
- Each table has an AUTO_INCREMENT primary key.
- Foreign keys enforce valid parent records.
- UNIQUE constraints prevent duplicate department names, roll numbers,
  emails, course codes, duplicate student-course-term enrollments and
  duplicate attendance dates for the same enrollment.
- NOT NULL ensures required values are supplied.
- CHECK limits course credit hours to 1–6 (MySQL 8.0.16+).
- ENUM restricts attendance_status to Present, Absent or Late.
- ON DELETE CASCADE is used for enrollment-dependent attendance records;
  department and teacher references use RESTRICT to protect referenced data.

NORMALIZATION
- 1NF: each field stores one atomic value; no repeating groups.
- 2NF: non-key attributes depend on the whole primary key. The enrollment
  relationship is stored as its own table instead of repeating course
  columns in the student table.
- 3NF: department, teacher, student and course details are stored once in
  their own tables. Enrollments stores the relationship and term-specific
  grade; attendance stores date-specific attendance.
- The junction table prevents a many-to-many relationship from being
  stored as a repeating list.

QUERY COVERAGE
The queries file includes SELECT, INSERT, UPDATE, DELETE examples,
INNER JOIN, LEFT JOIN, multi-table JOIN, GROUP BY, HAVING, COUNT, AVG,
SUM, NULLIF, filtering, sorting and attendance percentage.

IMPORTANT
- The script drops and recreates the six lab tables each time it is run.
  Back up any existing university_db data before rerunning schema.sql.
- Queries 18 changes one sample email. Queries 19 and 20 are commented
  out so they do not modify data unless you intentionally uncomment them.
- Sample names/emails are fictional classroom seed data.
- Export: in phpMyAdmin select university_db > Export > Quick > SQL > Go.

CHALLENGE
For a library database, create normalized tables such as authors, books,
members, loans and book_authors. Use book_authors as a junction table
because one book can have multiple authors and one author can write
multiple books.
