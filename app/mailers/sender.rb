#encoding: utf-8
#pierwszy mailer :)
class Sender < ActionMailer::Base
  helper [:application, :auctions]
  include ApplicationHelper, AuctionsHelper

  def ver_mail(hash)
    @hash = hash
    mail(:to => 'maverral@wp.pl', :from => 'mario@open.net', :subject => 'Testujemy mailera')
  end

  def user_commented(comment)
    @comment = comment
    subject = "Otrzymales komentarz"
    mail(:to => comment.receiver.email, :subject => subject)
  end

  def user_received_message(msg)
    @msg = Message.find(msg.id+1)
    subject = "Otrzymałeś prywatną wiadomość"
    mail(:to => msg.receiver.email, :subject => subject)
  end

  def auction_waiting_for_offer(auction)
    @auction = auction
    subject = "Aukcja \"#{escape_auction(auction)}\" przeszla w etap wyboru oferty"
    mail(:to => @auction.owner.email, :subject => subject)
  end

  def auction_created(auction)
    @auction = auction
    subject = "Aukcja \"#{escape_auction(auction)}\" została utworzona"
    mail(:to => @auction.owner.email, :subject => subject)
  end

  def auction_finished(auction)
    @auction = auction
    subject = "Aukcja \"#{escape_auction(auction)}\" zostala zakonczona"
    mail(:to => @auction.owner.email, :subject => subject)
  end

  def auction_canceled(auction)
    @auction = auction
    subject = "Aukcja \"#{escape_auction(auction)}\" zostala anulowana"
    mail(:to => @auction.owner.email, :subject => subject)
  end

  def auction_invited_user(auction, user)
    @auction = auction
    subject = "Aukcja \"#{escape_auction(auction)}\": zostales zaproszony do licytacji"
    @user = user
    mail(:to => user.email, :subject => subject)
  end

  def auction_won_offer(auction)
    @auction = auction
    @won_offer = auction.won_offer
    subject = "Twoja oferta zwyciezyla !"
    mail(:to => @won_offer.offerer.email, :subject => subject)
  end
end
