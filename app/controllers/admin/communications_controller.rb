class Admin::CommunicationsController < Admin::ApplicationController

  def destroy
    @id = params[:id]
    @flash = flash_t
    Communication.find(@id).destroy
  end
end
