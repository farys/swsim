class CategoriesController < ApplicationController
    before_filter :load_categories_to_menu
    def index
    end

    def show
        @category = Category.includes(:parent_links, :links).find(params[:id])
        @auctions = Auction.from_category @category
    end

    private

    def load_categories_to_menu
        @menu_categories = Category.includes(:links => [:parent, :category]).where("parent_id is NULL").order("parent_id ASC").order("name ASC").all
    end

end
