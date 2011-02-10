class MessagesController < ApplicationController
  
  def show
    @message = Message.find(
      params[:id], 
      :conditions => ['author_id=? OR receiver_id=?', @logged_user.id, @logged_user.id],
      :include => [:author, :receiver]
    )
  
    if @message.status == Message::UNREAD
      @message.status = Message::READ
      @message.save!
    end
  end

  def new
    
    @receiver = User.find(params[:receiver_id])
    @message = @logged_user.sent_messages.new# {:receiver => @receiver}
    
    if params.has_key?(:reply_message_id)
      @reply_message = @logged_user.received_messages.find(params[:reply_message_id])
      @message.topic = 'Re: '+@reply_message.topic
      @message.body = '<br /><br />'+@reply_message.author.name+' napisal: <br />'+@reply_message.body
    end
    @message.receiver = @receiver
  end
  
  def create
    
    @message = @logged_user.sent_messages.new params[:message]

    if @message.save
      if params.has_key?(:reply_message_id)
        @msg = @logged_user.received_messages.find(params[:reply_message_id])
        @msg.status = Message::REPLIED
        @msg.save
      end
      flash[:notice] = 'Wiadomosc zostala wyslana'
      redirect_to panel_user_path(@logged_user)
    else
      render :new
    end
  end
  
  def destroy
    @message = @logged_user.received_messages.find(params[:id])
    @message.status = Message::DELETED
    @message.save
    redirect_to panel_user_path(@logged_user)
  end
end
