-- LAB 10 REPORT QUERIES
USE university_db;

-- 1. Display all departments
SELECT * FROM departments;

-- 2. Display all students
SELECT * FROM students;

-- 3. Students with their department names (required basic query)
SELECT s.roll_number, CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       d.department_name
FROM students s
INNER JOIN departments d ON s.department_id = d.department_id
ORDER BY student_name;

-- 4. Teachers with their department names
SELECT CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
       d.department_name
FROM teachers t
JOIN departments d ON t.department_id = d.department_id;

-- 5. Courses with department and teacher
SELECT c.course_code, c.course_title, d.department_name,
       CONCAT(t.first_name, ' ', t.last_name) AS teacher_name
FROM courses c
JOIN departments d ON c.department_id = d.department_id
JOIN teachers t ON c.teacher_id = t.teacher_id;

-- 6. Student course enrollment details
SELECT s.roll_number, CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_code, c.course_title, e.semester, e.academic_year
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 7. Count students in each department
SELECT d.department_name, COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_students DESC;

-- 8. Course enrollment counts (required basic query)
SELECT c.course_code, c.course_title, COUNT(e.enrollment_id) AS total_enrollments
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
ORDER BY total_enrollments DESC;

-- 9. Average credit hours by department
SELECT d.department_name, AVG(c.credit_hours) AS average_credit_hours
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name;

-- 10. Attendance percentage by student (Present counts as attended; Late is separate)
SELECT s.roll_number, CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       COUNT(a.attendance_id) AS classes_recorded,
       SUM(a.attendance_status = 'Present') AS present_count,
       ROUND(100.0 * SUM(a.attendance_status = 'Present') /
             NULLIF(COUNT(a.attendance_id), 0), 2) AS present_percentage
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN attendance a ON e.enrollment_id = a.enrollment_id
GROUP BY s.student_id, s.roll_number, s.first_name, s.last_name;

-- 11. Total attendance by status
SELECT attendance_status, COUNT(*) AS total_records
FROM attendance
GROUP BY attendance_status;

-- 12. Students with no enrollment
SELECT s.student_id, s.roll_number, s.first_name, s.last_name
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- 13. Courses with more than two enrolled students
SELECT c.course_code, c.course_title, COUNT(e.student_id) AS enrolled_students
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
HAVING COUNT(e.student_id) > 2;

-- 14. Find students enrolled in Database Systems
SELECT DISTINCT s.roll_number, s.first_name, s.last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_title = 'Database Systems';

-- 15. Show grades and course information
SELECT s.roll_number, CONCAT(s.first_name, ' ', s.last_name) AS student_name,
       c.course_code, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY c.course_code, s.roll_number;

-- 16. Department-wise number of teachers
SELECT d.department_name, COUNT(t.teacher_id) AS total_teachers
FROM departments d
LEFT JOIN teachers t ON d.department_id = t.department_id
GROUP BY d.department_id, d.department_name;

-- 17. Students admitted after 1 January 2025
SELECT roll_number, first_name, last_name, admission_date
FROM students
WHERE admission_date > '2025-01-01'
ORDER BY admission_date;

-- 18. Update a student's email (CRUD: UPDATE)
UPDATE students
SET email = 'ayesha.updated@example.com'
WHERE roll_number = '2K25-SWE-017';

-- 19. Insert a new department (CRUD: INSERT example)
-- Uncomment to run once; department_name must remain unique.
-- INSERT INTO departments (department_name, office_location)
-- VALUES ('Cyber Security', 'Block E');

-- 20. Delete a sample attendance record (CRUD: DELETE example)
-- Uncomment to run; use a specific attendance_id.
-- DELETE FROM attendance WHERE attendance_id = 26;

-- 21. Count all students, teachers, courses and enrollments
SELECT
  (SELECT COUNT(*) FROM students) AS students_total,
  (SELECT COUNT(*) FROM teachers) AS teachers_total,
  (SELECT COUNT(*) FROM courses) AS courses_total,
  (SELECT COUNT(*) FROM enrollments) AS enrollments_total;
