class TemplatesController < ApplicationController
  before_action :set_template, only: %i[show edit]

  def index
    @templates = Template.all
  end

  def show
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end
end
