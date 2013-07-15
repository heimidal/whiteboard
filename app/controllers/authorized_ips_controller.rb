class AuthorizedIpsController < ApplicationController
  def edit
    @authorized_ip = Item.find(params[:id])
  end


end
