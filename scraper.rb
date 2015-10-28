require_relative './sneaky_secrets.rb'
require 'pry'
require "active_record"
require 'nokogiri'
require 'open-uri'
# require 'httparty'


require_relative './email_config.rb'
require_relative './database_config.rb'
require_relative './job_posting.rb'


doc = Nokogiri::HTML(open("http://vancouver.craigslist.ca/search/sof"))
# doc = Nokogiri::HTML(HTTParty.get("http://vancouver.craigslist.ca/search/sof"))

JobPosting.destroy_all

start_time = Time.now - 1.days
end_time = Time.now
range = start_time..end_time
posts_from_range = []

rows = doc.css(".row")
rows.each_with_index do |row, index|
  date_posted = row.children.css(".pl").children[1].attributes["datetime"].value

  # only save posts from the range we want
  next unless range.cover? date_posted.to_time
  
  path = row.children.css(".i").first.attributes["href"].value
  post = JobPosting.new(title: row.text, date_posted: date_posted, link: "http://vancouver.craigslist.ca" + path)

  if (!row.children.css(".l2 .pnr small").empty?) 
    location = row.children.css(".l2 .pnr small").text
    location = location[location.index("(") + 1 ,location.rindex(")")-2]
    post.location = location
  end

  show_page = Nokogiri::HTML(open(post.link))

  post.compensation = show_page.css(".attrgroup b").text
  post.content_text = show_page.css("#postingbody").text
  post.content_html = show_page.css("#postingbody").first
  post.employment_type = show_page.css(".attrgroup b")[1].text

  post.save
  posts_from_range << post
end

  body = ""
  posts_from_range.each do |post|
  body = body + <<-FOO
  <br>
  <br>
  <br>
  ***********************************************************************
  <br>
  <h3>#{post.title}</h3>
  <p><b>Employment Type: </b>#{post.employment_type}</p>
  <p><b>Location: </b> #{post.location || "none-provided"}</p>
  <p>#{post.link}</p>
  <p><b>Compensation: </b> #{post.compensation}</p>
  
  #{post.content_html}

  FOO
end
subject = "Job postings from:  #{Date.today.strftime("%A")}"
send_email ENV["recipient"], subject, body