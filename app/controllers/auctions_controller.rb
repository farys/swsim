#encoding: utf-8
class AuctionsController < ApplicationController
  before_filter :to_search_event, :only => [:search, :result]

  def index
    @auctions = Auction.with_status(:active).order("id DESC").limit(18)
    title_t
  end

  def show
    options = {:include => [:owner, {:offers => :offerer}, :communications]}
    @auction = Auction.find(params[:id], options)

    if @auction.expired_at.past?
      @auction.status = Auction::STATUSES[:finished]
    end

    @offers = @auction.offers
    @tags = @auction.tags
    
    unless (@auction.is_allowed_to_see?(@logged_user))
      render :text => flash_t, :status => :forbidden
      return
    end
    
    @alert = Alert.new
    @auction.increment! :visits
    
    unless @logged_user.nil?
    	@rated = @auction.rated_by?(@logged_user)
    end
    title_t
  end

  def search
    title_t
  end
  
  def result
    @query = params[:query] ||= ''
    @search_in_description = params[:search_in_description] ||= false
    @show_tags = false #params[:show_tags] ||= false #tagi wyswietlane od razu po zaladowaniu formularza
    @elapsed_time = Benchmark.realtime do |x|
      @auctions = Auction.search_by_sphinx(@query, @search_in_description, @selected_tag_ids, @budgets_ids)#Auction.has_tags.all {@selected_tags})
    end
    title_t
  end
  
  private

  def to_search_event
    params[:tag_ids] = {params[:tag_ids] => params[:tag_ids]} if params[:tag_ids].instance_of?(String)
    @selected_tag_ids = (params[:tag_ids] || Hash.new).values.collect{|tag| tag.to_i}
    @groups = Group.all
    @budgets_ids = (params[:budgets_ids] || Hash.new).values
  end
end
