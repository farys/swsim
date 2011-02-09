class AuctionsController < ApplicationController
#todo przeniesc do html?
  #uses_tiny_mce :options => {
   # :theme => 'advanced',
   # :plugins => %w{ table fullscreen },
   # :width => '900px'
  #}
  before_filter :find_auction, :except => [:new, :create, :search, :result]
  before_filter :find_all_tags, :only => [:search, :result]
  
  def show
    @alert = Alert.new :author_id => @logged_user.id
  end

  def new
    @auction = Auction.new
    load_form_data
  end

  def create
    @auction = Auction.new(params[:auction])
    #todo
    @auction.owner = @logged_user

    if @auction.save
      @auction.tags << Tag.from_text(@auction.description + ' ' + @auction.title)
      
      flash[:notice] = 'Aukcja zostala zapisana i opublikowana'
      redirect_to @auction
    else
      load_form_data
      render :action => :new
    end
  end

  def won_offer
  end

  def update_won_offer
    attr = {:won_offer => @auction.offers.latest.find(params[:auction][:won_offer_id])}

    if @auction.update_attributes(attr)
      flash[:notice] = 'Zwycieska oferta zostala wyznaczona'
      redirect_to auction_path(@auction)
    else
      render :won_offer
    end
  end

  def stage
  end

  def update_stage
    if params.has_key?(:to_accept_ids) && @auction.to_next_stage(params[:to_accept_ids])
      flash[:notice] = 'Aukcja przeszla do kolejnego etapu'
      redirect_to auction_path(@auction)
    else
      flash[:error] = 'Nie wybrales zadnych ofert, chcesz anulowac aukcje?'
      redirect_to cancel_auction_path(@auction)
    end
  end

  def cancel
    @auction.status = Auction::STATUS_CANCELED
    if @auction.save
      flash[:warning] = 'Aukcja zostala anulowana'
    else
      flash[:error] = 'Anulowanie aukcji nie powiodlo sie! Skontaktuj sie z administratorem serwisu'
    end
    redirect_to panel_user_path(@logged_user)
  end

  def search
  end
  
  def result
    @selected_tags = (params[:tags] ||= Hash.new).keys
    @query = params[:query] ||= ''
    @search_in_description = params[:search_in_description] ||= false
    @show_tags = false #params[:show_tags] ||= false #tagi wyswietlane od razu po zaladowaniu formularza
    @elapsed_time = Benchmark.realtime do |x|
      @auctions = Auction.search(@query, @search_in_description, params[:tags].keys)#Auction.has_tags.all {@selected_tags})
    end
  end
  
  private
  def load_form_data
    @categories_to_list = Category.get_array
  end

  def find_auction
    options = nil
    options = {:include => [:owner, {:offers => :offerer}, :communications]} if params[:action].eql?('show')
    @auction = Auction.find(params[:id], options)
  end
  
  def find_all_tags
    @tags = Tag.all
  end
end
