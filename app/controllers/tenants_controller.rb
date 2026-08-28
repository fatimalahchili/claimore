class TenantsController < ApplicationController
  before_action :set_property, only: %i[new create]
  before_action :set_tenant, only: %i[update destroy]
  before_action :authorize_main_tenant!, only: %i[new create]

  def index
    @tenants = @property.tenants
  end

  def new
    @tenant = Tenant.new
    @tenant.property = @property
    @query = params[:query]
    @users = @query.present? ? search_users(@query) : User.none
  end

  def create
    @tenant = Tenant.new(tenant_params)
    @tenant.property = @property
    if @tenant.save
      TenantMailer.added(@tenant).deliver_later
      redirect_to @tenant.property
    else
      redirect_to new_property_tenant_path(@property), alert: @tenant.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    if @tenant.update(tenant_params)
      redirect_to @tenant.property
    else
      redirect_to @tenant.property, alert: "Tenant could not be updated."
    end
  end

  def destroy
    @tenant.destroy
    redirect_to @tenant.property
  end

  private

  def search_users(query)
    User.where.not(id: @property.tenants.select(:user_id))
        .where("email ILIKE ?", "%#{query}%")
  end

  def authorize_main_tenant!
    return if @property.tenants.exists?(user: current_user, role: "main_tenant")

    redirect_to root_path, alert: "Not authorized."
  end

  def set_property
    @property = Property.find(params[:property_id])
  end

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(:user_id)
  end
end
