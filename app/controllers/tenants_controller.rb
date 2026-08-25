class TenantsController < ApplicationController

   def index
    @tenants = Tenant.all
  end

  def show
  end

  def new
    @tenant = Tenant.new
  end

  def create
    @tenant = Tenant.new(tenant_params)
    if @tenant.save
      redirect_to @tenant, notice: "Tenant was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    @tenant.destroy
    redirect_to tenants_path, notice: "Tenant was successfully removed."
  end
  
  private
  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(:user_id, :claim_id, :property_id)
  end
end
