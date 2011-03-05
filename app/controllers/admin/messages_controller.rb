class Admin::MessagesController < Admin::ApplicationController
  before_filter :new_message, :only => [:new, :create]

  def index
    @status = "received"
    @messages = @logged_user.find_messages(:received, params[:page])
  end
  
  def sent
    @status = "sent"
    @messages = @logged_user.find_messages(:sent, params[:page])
    render :index
  end
  
  def show
    @message = @logged_user.messages.find(params[:id])
  
    if @message.status == Message::STATUS_UNREAD
      @message.read!
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
      flash[:notice] = t("flash.messages.create")
      redirect_to sent_admin_messages_path
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
    @message.delete!
      flash[:warning] = t("flash.messages.destroy")
      redirect_to admin_messages_path
  end

  private
  def new_message
    data = params[:message] || {:receiver_login => params[:receiver_login]}
    @message = @logged_user.new_message(data)
  end
end