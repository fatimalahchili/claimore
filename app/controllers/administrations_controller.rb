class AdministrationsController < ApplicationController
  def index
    @admistrations = Admistration.all
  end

  def show
    @admistration = Admistration.find(params[:id])
  end
end
