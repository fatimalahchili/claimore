class TemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit]

  def index
    @templates = Template.all
  end

  def show
  end

  def new
    @template = Template.new
  end

  def edit
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end
end
