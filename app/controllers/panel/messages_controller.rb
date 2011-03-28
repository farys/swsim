class Panel::MessagesController < Panel::ApplicationController
	before_filter :new_message, :only => [:new, :create]
	def index
		@status = "received"
		@messages = current_user.find_messages(:received, params[:page])
		title_t :received
	end

	def sent
		@status = "sent"
		@messages = current_user.find_messages(:sent, params[:page])
		title_t :sent
		render :index
	end

	def show
		@message = current_user.messages.find(params[:id])

		if @message.status == Message::STATUS_UNREAD
      @message.read!
		end
	end

	def new
	end

	def create
		if @message.send_to_receiver
      Sender.user_received_message(@message).deliver
			if params.has_key?(:reply_message_id)
				@msg = current_user.messages.received.find(params[:reply_message_id])
        @msg.replied!
			end
			flash_t :notice
			redirect_to sent_panel_messages_path
		else
			render :new
		end
	end

	def reply
		@old_message = current_user.messages.received.find(params[:id])
		@message = @old_message.prepare_reply_message
		@receiver = @message.receiver
		render :new
	end

	def destroy
		@message = current_user.messages.find(params[:id])
		@message.delete!
		flash_t :warning
		redirect_to panel_messages_path
	end

	private

	def new_message
		data = params[:message] || {:receiver_login => params[:receiver_login]}
		@message = current_user.new_message(data)
	end
end