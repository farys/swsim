class Panel::MessagesController < Panel::ApplicationController
  before_filter :new_message, :only => [:new, :create]

  def index
    @status = "received"
    @messages = @logged_user.find_messages(:received, params[:page])
    @title = "Odebrane"
  end
  
  def sent
    @status = "sent"
    @messages = @logged_user.find_messages(:sent, params[:page])
    @title = "Wyslane"
    render :index
  end
  
  def show
    @message = @logged_user.messages.find(params[:id])
  
    if @message.status == Message::STATUS_UNREAD
      @message.status = Message::STATUS_READ
      unless @message.save
        flash[:error] = 'Nie mozna bylo zmienic statusu wiadomosci. Skontaktuj sie z administratorem serwisu'
      end
    end
  end


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

  def reply
    @old_message = @logged_user.messages.received.find(params[:id])
    @message = @old_message.prepare_reply_message
    @receiver = @message.receiver
    render :new
  end
  
  def destroy
    @message = @logged_user.messages.find(params[:id])
    @message.status = Message::STATUS_DELETED
    if @message.save
      flash[:warning] = 'Wiadomosc zostala usunieta'
      redirect_to panel_messages_path
    else
      flash[:error] = 'Nie mozna bylo usunac wiadomosci. Skontaktuj sie z administratorem serwisu'
      redirect_to panel_message_path(@message)
    end
  end

  private
  def new_message
    data = params[:message] || {:receiver_login => params[:receiver_login]}
    @message = @logged_user.new_message(data)
  end
end