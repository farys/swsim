class MessagesController < ApplicationController
  before_filter :login_required
  before_filter :load_data
  
  def new
  end
  
  def create    
    if @message.send_to_receiver
      
      if params.has_key?(:reply_message_id)
        @msg = @logged_user.messages.received.find(params[:reply_message_id])
        @msg.status = Message::STATUS_REPLIED
        @msg.save
      end
      flash[:notice] = 'Wiadomosc zostala wyslana'
      redirect_to sent_panel_messages_path
    else
      render :new
    end
  end
  
  private
  def load_data
    data = params[:message] || {:receiver_id => params[:user_id]}
    @message = @logged_user.new_message(data)
    @receiver = @message.receiver
  end
end