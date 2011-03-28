ActionMailer::Base.smtp_settings = {
  :address              => "smtp.poczta.onet.pl",
  :port                 => 587,
  :user_name            => "rafais1@op.pl",
  :password             => "dupaztrupa",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
ActionMailer::Base.default(:return_path => "rafais1@op.pl", :from => "rafais1@op.pl")
class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "#{message.to} #{message.subject}"
    message.to = "rafais1@op.pl"
  end
end
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
