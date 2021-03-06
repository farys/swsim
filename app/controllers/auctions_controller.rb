#encoding: utf-8
class AuctionsController < ApplicationController
  before_filter :to_search_event, :only => [:search, :result]
  skip_before_filter :authenticate

  def index
    @auctions = Auction.public_auctions.includes(:budget).with_status(:active).order("id DESC").limit(18)
    @users = User.count
    @blogs = Blogpost.order("id DESC").limit(18).includes(:user)
    @projects = Project.where(:status => Project::STATUSES[:active]).count
    title_t
  end

  def show
    options = {:include => [:owner, {:offers => :offerer}, :communications]}
    @auction = Auction.find(params[:id], options)

    @made_offer = @auction.made_offer?(current_user)
    
    if @auction.expired_at.past?
      @auction.status = Auction::STATUSES[:finished]
    end

    unless (@auction.allowed_to_see?(current_user))
      render :text => t("flash.general.error.privileges"), :status => :forbidden
      return
    end

    @offers = @auction.offers
    @tags = @auction.tags

    @alert = Alert.new
    @auction.increment! :visits
    
    unless current_user.nil?
    	@rated = @auction.rated_by?(current_user) || @auction.owner?(current_user)
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
