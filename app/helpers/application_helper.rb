# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
include ReCaptcha::ViewHelper #wazne dla recaptcha

  def escape_time(date = DateTime.now, time_new_line = false)
    t = (time_new_line)? '<br />' : ''
    date.strftime('%d-%m-%Y' + t + ' %H:%M')
  end
  
  def escape_date(date = DateTime.now)
    date = date.strftime('%d-%m-%Y')
  end

  #gdy zwroci hash z slownika to obiekt ma ustawiony status bez pokrycia w STATUSES
  def escape_status(model, status = nil)
    status = model.class::STATUSES.invert[(status || model.status)]
    t("#{model.class.name.downcase}.statuses.#{status.to_s}")
  end
	
	#Metoda tlumaczy zawartosc kolumny w modelu
  def escape_column(model, column)
    t("#{model.class.name.downcase}.#{column}.#{model.send(column)}")
  end
  
  #Metoda tlumaczy nazwe modelu
  def model_t(model = nil)
    translation = t("activerecord.models.#{model}")
    return translation unless model.nil?    
  end
  
  #Metoda tlumaczy atrybut modelu
  def attribute_t(attribute = nil)
    translation = t("activerecord.attributes.#{attribute}")
    return translation unless attribute.nil?
  end
  
  #konwetuje rozmiar pliku w bajtach
  def escape_file_size(size = 1)
  	case size
  	when 1..1.kilobyte - 1
  	  translation = t('number.human.storage_units.units.byte',
  	                  :count => size)
  		"#{size} #{translation}"
  	when 1.kilobyte..1.megabyte - 1
  		"#{(size/1024.0).round(2)} KiB"
  	else
  		"#{(size/1024.0**2).round(2)} MiB"
  	end
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
  
  #Metoda tworzy pola wyboru dla dostepnych rol
  def roles_for_select(model)
  	options = []
  	Role.find(:all, :select => 'id, name').each do |r|
  		unless r.name == 'owner' || r.name == 'leader'
  			options += [[escape_column(r, 'name'), r.id]]
  		end
  	end
  	options_for_select(options, model.send('id'))
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
  	content_tag(:button,
  							name,
  							:onclick => "window.location.href=\"#{url_for(url)}\"")
  end

  def include_wysiwyg
    tinymce_init = javascript_tag do
      "tinyMCE.init({theme: 'advanced', mode: 'textareas'});"
    end
    content_for :head, javascript_include_tag("tiny_mce/tiny_mce")+tinymce_init
  end

end
