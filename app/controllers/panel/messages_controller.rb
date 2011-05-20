class Panel::MessagesController < Panel::ApplicationController
	before_filter :new_message, :only => [:new, :create]
  before_filter :set_path

	def index
		@status = "received"
		@messages = current_user.find_messages(:received, params[:page])
		title_t :received
    render "panel/messages/index"
	end

	def sent
		@status = "sent"
		@messages = current_user.find_messages(:sent, params[:page])
		title_t :sent
    render "panel/messages/sent"
	end

	def show
		@message = current_user.messages.find(params[:id])

		if @message.status == Message::STATUSES[:unread]
      @message.read!
		end
    render "panel/messages/show"
	end

	def new
    render "panel/messages/new"
	end

	def create
		if @message.send_to_receiver
      Sender.user_received_message(@message).deliver
			if params.has_key?(:reply_message_id)
				@msg = current_user.messages.received.find(params[:reply_message_id])
        @msg.replied!
			end
			flash_t :notice
			redirect_to @sent_messages_path
		else
			render  "panel/messages/new"
		end
	end

	def reply
		@old_message = current_user.messages.received.find(params[:id])
		@message = @old_message.prepare_reply_message
		@receiver = @message.receiver
		render  "panel/messages/new"
	end

	def destroy
		@message = current_user.messages.find(params[:id])
		@message.delete!
		flash_t :notice
		respond_to do |format|
      format.html { (@message.author.eql?(current_user))? redirect_to(@sent_messages_path) : redirect_to(@messages_path) }
      format.js { render "panel/messages/destroy"}
    end
  end

  private

  def new_message
    data = params[:message] || {:receiver_login => params[:receiver_login]}
    @message = current_user.new_message(data)
    @message.author_id = current_user.id
  end

  def set_path
    @sent_messages_path = sent_panel_messages_path
    @messages_path = panel_messages_path
    @module = :panel
  end
end