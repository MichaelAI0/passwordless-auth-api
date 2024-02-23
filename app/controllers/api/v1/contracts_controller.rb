class Api::V1::ContractsController < ApplicationController
  before_action :authenticate_request!

  def show
    @contract = Contract.find(params[:id])
    render json: @contract
  end
end
