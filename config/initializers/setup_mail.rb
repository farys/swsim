ActionMailer::Base.smtp_settings = {
  :address              => "smtp.wp.pl",
  :port                 => 587,
  :user_name            => "jasiek1234567@wp.pl",
  :password             => "dupadupa",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.default(:return_path => "maverral@wp.pl", :from => "maverral@wp.pl")
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "maverral@wp.pl"
  end
end
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
