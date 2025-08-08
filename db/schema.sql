-- Recruitment Portal Database Schema (MySQL 8+)
-- Safe to run multiple times

-- Create database
CREATE DATABASE IF NOT EXISTS recruitment_portal
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE recruitment_portal;

-- Roles table
CREATE TABLE IF NOT EXISTS roles (
  id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(32) NOT NULL UNIQUE,
  description VARCHAR(255) NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  phone VARCHAR(25) NULL,
  password_hash VARCHAR(255) NOT NULL,
  role_id SMALLINT UNSIGNED NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_users_role_id (role_id),
  CONSTRAINT fk_users_role FOREIGN KEY (role_id)
    REFERENCES roles (id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Candidates table
CREATE TABLE IF NOT EXISTS candidates (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id BIGINT UNSIGNED NULL,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NULL,
  phone VARCHAR(25) NULL,
  current_location VARCHAR(120) NULL,
  preferred_location VARCHAR(120) NULL,
  total_experience_years DECIMAL(4,1) NOT NULL DEFAULT 0.0,
  notice_period ENUM('Immediate','15 days','30 days') NOT NULL DEFAULT '30 days',
  availability_date DATE NULL,
  skills_json JSON NULL,
  skills_flat TEXT NULL,
  last_updated DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  generic_notes TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY uq_candidates_user_id (user_id),
  INDEX idx_candidates_location (current_location),
  INDEX idx_candidates_pref_location (preferred_location),
  INDEX idx_candidates_experience (total_experience_years),
  INDEX idx_candidates_notice (notice_period),
  INDEX idx_candidates_last_updated (last_updated),
  FULLTEXT INDEX ft_candidates_text (full_name, skills_flat, generic_notes),
  CONSTRAINT fk_candidates_user FOREIGN KEY (user_id)
    REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Candidate skills (normalized, optional in addition to JSON field)
CREATE TABLE IF NOT EXISTS candidate_skills (
  candidate_id BIGINT UNSIGNED NOT NULL,
  skill VARCHAR(100) NOT NULL,
  PRIMARY KEY (candidate_id, skill),
  INDEX idx_candidate_skill (skill),
  CONSTRAINT fk_candidate_skills_candidate FOREIGN KEY (candidate_id)
    REFERENCES candidates (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Resumes table
CREATE TABLE IF NOT EXISTS resumes (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  candidate_id BIGINT UNSIGNED NOT NULL,
  original_filename VARCHAR(255) NOT NULL,
  stored_filename VARCHAR(255) NOT NULL,
  mime_type VARCHAR(100) NOT NULL,
  size_bytes BIGINT UNSIGNED NOT NULL,
  text_content LONGTEXT NULL,
  uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_resumes_candidate_id (candidate_id),
  FULLTEXT INDEX ft_resumes_text (text_content),
  CONSTRAINT fk_resumes_candidate FOREIGN KEY (candidate_id)
    REFERENCES candidates (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Extracted keywords and vectors for fast search/ranking
CREATE TABLE IF NOT EXISTS candidate_keywords (
  candidate_id BIGINT UNSIGNED NOT NULL,
  keywords_json JSON NOT NULL,
  vector_json JSON NULL,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (candidate_id),
  CONSTRAINT fk_candidate_keywords_candidate FOREIGN KEY (candidate_id)
    REFERENCES candidates (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Basic job descriptions table (future extension, minimal now)
CREATE TABLE IF NOT EXISTS job_descriptions (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  description TEXT NOT NULL,
  keywords_json JSON NULL,
  created_by BIGINT UNSIGNED NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_job_desc_created_by (created_by),
  CONSTRAINT fk_job_desc_user FOREIGN KEY (created_by)
    REFERENCES users (id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Useful views (optional)
CREATE OR REPLACE VIEW v_candidate_search AS
SELECT c.id,
       c.full_name,
       c.email,
       c.phone,
       c.current_location,
       c.preferred_location,
       c.total_experience_years,
       c.notice_period,
       c.skills_flat,
       c.last_updated
FROM candidates c;