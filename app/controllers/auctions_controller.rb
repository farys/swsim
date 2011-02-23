#encoding: utf-8
class AuctionsController < ApplicationController
  before_filter :to_search_event, :only => [:search, :result]

  def show
    options = {:include => [:owner, {:offers => :offerer}, :communications]}
    @auction = Auction.find(params[:id], options)
    
    unless (@auction.is_allowed_to_see?(@logged_user))
      render :text => 'Nie masz prawa dostępu do aukcji', :status => :forbidden
      return
    end
    
    @alert = Alert.new
    @auction.increment! :visits
    
    unless @logged_user.nil?
    	@rated = @auction.rated_by?(@logged_user)
    end
  end

  def search
  end
  
  def result
    @selected_tags = (params[:tags] ||= Hash.new).keys
    @query = params[:query] ||= ''
    @search_in_description = params[:search_in_description] ||= false
    @show_tags = false #params[:show_tags] ||= false #tagi wyswietlane od razu po zaladowaniu formularza
    @elapsed_time = Benchmark.realtime do |x|
      @auctions = Auction.search_by_sphinx(@query, @search_in_description, params[:tags].keys, @budgets_ids)#Auction.has_tags.all {@selected_tags})
    end
  end
  
  private

  def to_search_event
    @budgets_ids = params[:budgets_ids] || Array.new
    @tags = Tag.order("name ASC").all
  end
end
