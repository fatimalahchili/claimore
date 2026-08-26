class PropertiesController < ApplicationController
  before_action :set_property, only: %i[update destroy show]
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

  def update
    if @property.update(property_params)
      redirect_to @property
    else
      render "properties/new"
    end
  end

  def destroy
    @property.destroy
    redirect_to new_property_path
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:address, :moved_on)
  end
end
