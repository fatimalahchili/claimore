class TenantsController < ApplicationController
  before_action :set_property, only: %i[new create]
  before_action :set_tenant, only: %i[update destroy]

  def index
    @tenants = @property.tenants
  end

  def new
    @tenant = Tenant.new
    @tenant.property = @property
  end

  def create
    @tenant = Tenant.new(tenant_params)
    @tenant.property = @property
    if @tenant.save
      redirect_to @tenant.property
    else
      render "tenants/new"
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

  def set_property
    @property = Property.find(params[:property_id])
  end

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(:user_id, :status)
  end
end
