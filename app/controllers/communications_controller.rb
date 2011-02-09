class CommunicationsController < ApplicationController
   #todo przeniesc do html?
  uses_tiny_mce :options => {
    :theme => 'advanced',
    :plugins => %w{ table fullscreen },
    :width => '900px',
    :editor_selector => '',
    :theme_advanced_buttons1 => 'bold,italic,underline,strikethrough,separator,justifyleft,justifycenter,justifyright,justifyfull,fontselect,fontsizeselect,outdent,indent,forecolor,backcolor,bullist,numlist,unlink',
    :theme_advanced_buttons2 => 'image,separator,undo,redo,cleanup,separator,sub,sup,charmap,tablecontrols',
    :theme_advanced_buttons3 => '',
    :convert_fonts_to_spans => true,
    :font_size_style_values => '8pt,10pt,12pt,14pt,18pt,24pt,36pt'
  }
  
  def new
    @auction = Auction.find(params[:auction_id])
    @communication = @auction.communications.new
  end

  def create
    @auction = Auction.find(params[:auction_id])
    @communication = @auction.communications.new params[:communication]

    if @communication.save #@communication.save
      flash[:notice] = 'Komunikat został opublikowany'
      redirect_to @auction
    else
      render :new
    end
  end
end
