class RelationshipsController < ApplicationController
  before_filter :authenticate

  def create
    @user = User.find(params[:relationship][:watched_id])
    current_user.watch!(@user)
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).watched
    current_user.unwatch!(@user)
    redirect_to :back
  end
end
