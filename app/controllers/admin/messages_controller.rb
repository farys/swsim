class Admin::MessagesController < Admin::ApplicationController
  before_filter :new_message, :only => [:new, :create]

  def index
    @status = "received"
    @messages = @logged_user.find_messages(:received, params[:page])
    title_t :received
  end
  
  def sent
    @status = "sent"
    @messages = @logged_user.find_messages(:sent, params[:page])
    title_t :sent
    render :index
  end
  
  def show
    @message = @logged_user.messages.find(params[:id])
  
    if @message.status == Message::STATUS_UNREAD
      @message.read!
    end
    title_t
  end


  def new
    title_t
  end

  def create
    if @message.send_to_receiver

      if params.has_key?(:reply_message_id)
        @msg = @logged_user.messages.received.find(params[:reply_message_id])
        @msg.status = Message::STATUS_REPLIED
        @msg.save
      end
      redirect_to sent_admin_messages_path, :notice => flash_t
    else
      title_t :new
      render :new
    end
  end

  def reply
    @old_message = @logged_user.messages.received.find(params[:id])
    @message = @old_message.prepare_reply_message
    @receiver = @message.receiver
    title_t :new
    render :new
  end
  
  def destroy
    @message = @logged_user.messages.find(params[:id])
    @message.delete!
      flash[:warning] = flash_t
      redirect_to admin_messages_path
  end

  private
  def new_message
    data = params[:message] || {:receiver_login => params[:receiver_login]}
    @message = @logged_user.new_message(data)
  end
end