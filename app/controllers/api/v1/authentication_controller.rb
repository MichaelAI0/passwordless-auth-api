class Api::V1::AuthenticationController < ApplicationController
  def create
    user = user.find_or_create_by!(email: params[:user][:email])

    user.send_magic_link 

    head :ok 
  end

end
