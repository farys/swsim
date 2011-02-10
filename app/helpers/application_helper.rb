# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def escape_time(date = DateTime.now, time_new_line = false)
    t = (time_new_line)? '<br />' : ''
    date.strftime('%a %d-%m-%Y' + t + ' %H:%M')
  end
  
  def escape_date(date = DateTime.now)
    date.strftime('%d-%m-%Y')
  end
end
