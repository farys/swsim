class Panel::MessagesController < Panel::ApplicationController

  def index
    @messages = @logged_user.find_messages(:received, params[:page])
    @title = "Odebrane"
  end
  
  def sent
    @messages = @logged_user.find_messages(:sent, params[:page])
    @title = "Wyslane"
    render :index
  end
  
  def show
    @message = @logged_user.messages.find(params[:id])
  
    if @message.status == Message::STATUS_UNREAD
      @message.status = Message::STATUS_READ
      @message.save!
    end
  end
  
  def reply
    @old_message = @logged_user.messages.received.find(params[:id])
    @message = @logged_user.new_message(:receiver => @old_message.receiver)
    @message.prepare_reply_text!(@old_message)
    render :new
  end
  
  def destroy
    @message = @logged_user.messages.find(params[:id])
    @message.status = Message::STATUS_DELETED
    @message.save
    redirect_to :back
  end
end