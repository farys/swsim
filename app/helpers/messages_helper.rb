# Methods added to this helper will be available to all templates in the application.
module MessagesHelper
  def get_message_path(path, msg)
    settings = {
      :panel => {
        "reply_message_path" => ->{ reply_panel_message_path(msg)},
        "message_path" => ->{ panel_message_path(msg)}
      },
      :admin => {
        "reply_message_path" => ->{ reply_admin_message_path(msg)},
        "message_path" => ->{ admin_message_path(msg)}
      }
    }
    settings[@module][path].call
  end
end
