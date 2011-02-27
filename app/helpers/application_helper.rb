# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def escape_time(date = DateTime.now, time_new_line = false)
    t = (time_new_line)? '<br />' : ''
    date.strftime('%a %d-%m-%Y' + t + ' %H:%M')
  end
  
  def escape_date(date = DateTime.now)
    date.strftime('%d-%m-%Y')
  end

  def include_active_link_mechanism urls=Array.new
    current_path = request.fullpath
    current_path += "/new" if params[:action].eql?("create")
    
    urls = [urls] unless urls.instance_of?(Array)
    update_page_tag do |page|
      page.call("$().ready") do |p|
        p.assign :uri, [current_path]+urls
        p << "
          $('a[href=\"'+uri[0]+'\"]').addClass('active');
          for(var i=1; i < uri.length; i++){
            $('ul a[href=\"'+uri[i]+'\"]:first').addClass('active');
          }
        "

#        p[:a].each do |a|
#          a << "
          #link = $(this).attr('href');
          # var active_links_on_menu = $('.activeLink', $(this).parent().parent()).size();
          #
          #  if(uri[i] == link && active_links_on_menu == 0){
          #    $(this).addClass('activeLink')
          #  }
         # }#"
#        end
      end
    end
  end
end
