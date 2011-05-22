class Panel::AuctionsController < Panel::ApplicationController
  before_filter :load_auction, :except => [:index, :new, :create, :user_form]
  before_filter :new_auction_and_form_data, :only => [:new, :create]
  skip_before_filter :authenticate, :only => [:user_form]

  def index	
    @status = params[:status] || :active
    title_t @status
    @auctions = current_user.auctions.with_status(@status).paginate :per_page => 15, :page => params[:page]
  end
  
  def new
    unless params[:from_id].nil?
      @old_auction = current_user.auctions.find(params[:from_id])
      @auction = @old_auction.clone
      @auction.tag_ids = @old_auction.tag_ids
    end
    @auction.expired_after = 14
    title_t
  end

  def create
    if @auction.save
      Sender.auction_created(@auction).deliver

      unless @auction.invited_users.empty?
        @auction.invited_users.each do |inv|
          Sender.auction_invited_user(@auction, inv.user).deliver
        end
      end

      redirect_to auction_path(@auction), :notice => flash_t
    else
      title_t :new
      render :action => :new
    end
  end

  def offers
    redirect_to :back if @auction.won_offer != nil
    title_t
  end

  def update
    @offer = @auction.offers.find(params[:auction][:won_offer_id])
    if @auction.set_won_offer!(@offer)
      if params.include?(:create_project)
        @project = Project.create(
          :auction_id => @auction.id,
          :name => @auction.title,
          :description => @auction.description,
          :owner_id => @auction.owner_id,
          :leader_id => @auction.won_offer.offerer.id,
          :duration => @auction.won_offer.days
        )
        redirect_to project_info_path(@project)
      else
        Comment.create_from_auction(@auction)
        redirect_to auction_path(@auction), :notice => flash_t
      end
      Sender.auction_finished(@auction).deliver
      Sender.auction_won_offer(@auction).deliver

    else
      title_t :offers
      render :offers
    end
  end

  def destroy
    @auction.cancel!
    Sender.auction_canceled(@auction).deliver
    redirect_to panel_auctions_path, :notice => flash_t
  end

  def user_form
    render :layout => false
  end
  
  private
  def new_auction_and_form_data
    @auction = current_user.auctions.new(params[:auction])
    @auction.tag_ids = params[:tag_ids].values unless params[:tag_ids].nil?
    @auction.invited_user_ids = params[:invitations_ids].values unless params[:invitations_ids].nil?
    @invited_users = @auction.invited_users
    @groups = Group.all
  end

  def load_auction
    options = nil
    options = {:include => [:owner, {:offers => :offerer}, :communications, :invited_users]} if params[:action].eql?('show')
    @auction = current_user.auctions.find(params[:id], options)
    @offers = @auction.offers
  end
end
