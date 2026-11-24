-- LAB 10: MYSQL + SQL — UNIVERSITY RELATIONAL DATABASE
-- MySQL 8.0+ / phpMyAdmin
-- Run this complete script in phpMyAdmin > SQL.

CREATE DATABASE IF NOT EXISTS university_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE university_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS departments;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Departments: parent table
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    office_location VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- 2. Students belong to one department
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    roll_number VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    admission_date DATE NOT NULL,
    department_id INT NOT NULL,
    CONSTRAINT fk_students_department
      FOREIGN KEY (department_id) REFERENCES departments(department_id)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 3. Teachers belong to one department
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(60) NOT NULL,
    last_name VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    CONSTRAINT fk_teachers_department
      FOREIGN KEY (department_id) REFERENCES departments(department_id)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4. Each course belongs to a department and is assigned a teacher
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_title VARCHAR(120) NOT NULL,
    credit_hours TINYINT UNSIGNED NOT NULL,
    department_id INT NOT NULL,
    teacher_id INT NOT NULL,
    CONSTRAINT chk_course_credit_hours CHECK (credit_hours BETWEEN 1 AND 6),
    CONSTRAINT fk_courses_department
      FOREIGN KEY (department_id) REFERENCES departments(department_id)
      ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_courses_teacher
      FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
      ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Enrollment resolves the many-to-many relationship between students and courses
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    semester VARCHAR(30) NOT NULL,
    academic_year YEAR NOT NULL,
    grade VARCHAR(2) NULL,
    CONSTRAINT uq_student_course_term
      UNIQUE (student_id, course_id, semester, academic_year),
    CONSTRAINT fk_enrollments_student
      FOREIGN KEY (student_id) REFERENCES students(student_id)
      ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_enrollments_course
      FOREIGN KEY (course_id) REFERENCES courses(course_id)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Attendance is recorded for an enrolled student in a course
CREATE TABLE attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    attendance_date DATE NOT NULL,
    attendance_status ENUM('Present', 'Absent', 'Late') NOT NULL,
    remarks VARCHAR(255) NULL,
    CONSTRAINT uq_enrollment_attendance_date UNIQUE (enrollment_id, attendance_date),
    CONSTRAINT fk_attendance_enrollment
      FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id)
      ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- SEED DATA: insert parent records before child records.
INSERT INTO departments (department_name, office_location) VALUES
('Software Engineering', 'Block A'),
('Computer Science', 'Block B'),
('Information Technology', 'Block C'),
('Mathematics', 'Block D');

INSERT INTO students
(roll_number, first_name, last_name, email, admission_date, department_id) VALUES
('2K25-SWE-017', 'Ayesha', 'Samu', 'ayesha.samu@example.com', '2025-01-15', 1),
('2K25-SWE-018', 'Hamza', 'Gull', 'hamza.gull@example.com', '2025-01-15', 1),
('2K24-CS-011', 'Sara', 'Ahmed', 'sara.ahmed@example.com', '2024-01-12', 2),
('2K24-IT-021', 'Ali', 'Raza', 'ali.raza@example.com', '2024-01-12', 3),
('2K25-CS-009', 'Hina', 'Malik', 'hina.malik@example.com', '2025-01-15', 2),
('2K25-IT-014', 'Usman', 'Shah', 'usman.shah@example.com', '2025-01-15', 3);

INSERT INTO teachers
(first_name, last_name, email, hire_date, department_id) VALUES
('Mariam', 'Khan', 'mariam.khan@university.edu', '2020-08-01', 1),
('Bilal', 'Ahmed', 'bilal.ahmed@university.edu', '2019-02-10', 2),
('Nadia', 'Iqbal', 'nadia.iqbal@university.edu', '2021-03-15', 3),
('Omar', 'Farooq', 'omar.farooq@university.edu', '2018-09-01', 4);

INSERT INTO courses
(course_code, course_title, credit_hours, department_id, teacher_id) VALUES
('SWE-201', 'Object Oriented Programming', 3, 1, 1),
('SWE-305', 'Database Systems', 3, 1, 1),
('CS-210', 'Data Structures', 3, 2, 2),
('IT-220', 'Web Technologies', 3, 3, 3),
('MTH-101', 'Calculus', 3, 4, 4);

INSERT INTO enrollments
(student_id, course_id, enrollment_date, semester, academic_year, grade) VALUES
(1, 1, '2026-01-10', 'Spring', 2026, 'A'),
(1, 2, '2026-01-10', 'Spring', 2026, 'B'),
(1, 4, '2026-01-11', 'Spring', 2026, 'A'),
(2, 1, '2026-01-10', 'Spring', 2026, 'B'),
(2, 2, '2026-01-10', 'Spring', 2026, 'A'),
(3, 3, '2026-01-10', 'Spring', 2026, 'A'),
(3, 5, '2026-01-11', 'Spring', 2026, 'B'),
(4, 4, '2026-01-10', 'Spring', 2026, 'A'),
(4, 5, '2026-01-11', 'Spring', 2026, 'C'),
(5, 3, '2026-01-10', 'Spring', 2026, 'B'),
(5, 1, '2026-01-11', 'Spring', 2026, 'A'),
(6, 4, '2026-01-10', 'Spring', 2026, 'B');

INSERT INTO attendance (enrollment_id, attendance_date, attendance_status, remarks) VALUES
(1, '2026-02-02', 'Present', NULL),
(1, '2026-02-04', 'Present', NULL),
(1, '2026-02-06', 'Absent', 'No notice'),
(1, '2026-02-09', 'Late', 'Arrived 10 minutes late'),
(2, '2026-02-02', 'Present', NULL),
(2, '2026-02-04', 'Absent', NULL),
(3, '2026-02-02', 'Present', NULL),
(3, '2026-02-04', 'Present', NULL),
(4, '2026-02-02', 'Present', NULL),
(4, '2026-02-04', 'Present', NULL),
(5, '2026-02-02', 'Absent', NULL),
(5, '2026-02-04', 'Present', NULL),
(6, '2026-02-02', 'Present', NULL),
(6, '2026-02-04', 'Late', NULL),
(7, '2026-02-02', 'Present', NULL),
(7, '2026-02-04', 'Present', NULL),
(8, '2026-02-02', 'Present', NULL),
(8, '2026-02-04', 'Absent', NULL),
(9, '2026-02-02', 'Present', NULL),
(9, '2026-02-04', 'Present', NULL),
(10, '2026-02-02', 'Absent', NULL),
(10, '2026-02-04', 'Present', NULL),
(11, '2026-02-02', 'Present', NULL),
(11, '2026-02-04', 'Present', NULL),
(12, '2026-02-02', 'Late', NULL),
(12, '2026-02-04', 'Present', NULL);
