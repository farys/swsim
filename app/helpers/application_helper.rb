# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
include ReCaptcha::ViewHelper #wazne dla recaptcha

	
  def escape_time(date = DateTime.now, time_new_line = false)
    t = (time_new_line)? '<br />' : ''
    date.strftime('%a %d-%m-%Y' + t + ' %H:%M')
  end
  
  def escape_date(date = DateTime.now)
    date = date.strftime('%d-%m-%Y')
  end

  #gdy zwroci hash z slownika to obiekt ma ustawiony status bez pokrycia w STATUSES
  def escape_status(model, status = nil)
    status = model.class::STATUSES.invert[(status || model.status)]
    t("#{model.class.name.downcase}.statuses.#{status.to_s}")
  end

  # Metoda tworzy pola wyboru dla kolumny status
  # wymogiem jest hash STATUSES o zawartosci np. {:active => 0, :hidden => 1}
  # metoda zaglada do slownika po nazwy statusow
  def statuses_for_select(model)
    options = []
    model.class::STATUSES.each_pair do |k, v|
      options += [[escape_status(model, v), v]]
    end
    options_for_select(options, model.status)
  end
  
  def escape_column(model, column)
    t("#{model.class.name.downcase}.#{column}.#{model.send(column)}")
  end

  def column_for_select(model, column)
  	options = []
  	model.class.all.each do |n|
  		unless n.name == 'owner' || n.name == 'leader'
  			options += [[escape_column(n, column).capitalize, n.id]]
  		end
  	end
  	options_for_select(options, model.send(column))
  end
  
  def flash_t(type=nil)
    params = request.parameters.clone
    params["controller"]["/"] = "." if params["controller"].include?("/")
    translation = t("flash.#{params["controller"]}.#{params[:action]}")
    text = "<div class=\"#{type}\">#{translation}</div>"
    return text unless type.nil?
  end
  
  #Dodaje link w postaci buttona, domyslnie nazwa: test, url: '#'
  def button(name = 'test', url = '#')
  	content_tag(:button, name, :onclick => "window.location.href=\"#{url_for(url)}\"")
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
