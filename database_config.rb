ActiveRecord::Base.establish_connection(
  adapter:  'postgresql', # or 'postgresql' or 'sqlite3'
  database: 'job_scraper',
  username: ENV["db_user"],
  password: ENV["db_password"],
  encoding: 'unicode',
  pool: 5
)