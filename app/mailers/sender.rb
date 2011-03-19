#pierwszy mailer :)
class Sender < ActionMailer::Base
  default :from => 'zenek@sender.com',
          :return_path => 'system@example.com'

    def ver_mail(hash)
    	@hash = hash
	    mail(:to => 'maverral@wp.pl', :from => 'mario@open.net', :subject => 'Testujemy mailera')
    end

end
