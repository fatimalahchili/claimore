class PropertiesController < ApplicationController
  before_action :set_property, only: %i[edit update destroy show]
  before_action :authorize_property!, only: %i[edit update destroy show]

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      redirect_to @property
    else
      render "properties/new"
    end
  end

  def show
  end

  def edit
  end

  def update
    if @property.update(property_params)
      redirect_to @property
    else
      render "properties/edit"
    end
  end

  def destroy
    @property.destroy
    redirect_to new_property_path
  end

  private

  def authorize_property!
    return if Claim.where(property: @property).flat_map(&:users).include?(current_user)

    redirect_to root_path, alert: "Not authorized."
  end

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:address, :moved_on)
  end
end
