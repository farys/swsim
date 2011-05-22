class Admin::MessagesController < Panel::MessagesController

  private
  def set_path
    @sent_messages_path = sent_admin_messages_path
    @messages_path = panel_messages_path
    @module = :admin
  end
end