
DROP TABLE job_postings;
CREATE TABLE IF NOT EXISTS job_postings(
   id SERIAL PRIMARY KEY   NOT NULL,
   location           TEXT,
   date_posted  TIMESTAMP,
   content_text   TEXT,
   content_html   TEXT,
   title        TEXT,
   compensation TEXT,
   employment_type TEXT,
   post_id INT,
   link TEXT
);
