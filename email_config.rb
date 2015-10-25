require 'mail'
require_relative './sneaky_secrets.rb'


options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'localhost',
            :user_name            => ENV["user_name"],
            :password             => ENV["password"],
            :authentication       => 'plain',
            :enable_starttls_auto => true  }



Mail.defaults do
  delivery_method :smtp, options
end

def send_email recipient, subject, body
  Mail.deliver do
         to recipient
       from ENV["user_name"]
    subject subject
    html_part do
      content_type 'text/html; charset=UTF-8'
      body body
    end
  end
end
