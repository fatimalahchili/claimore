class TenantsController < ApplicationController
  before_action :set_claim, only: %i[new create]
  before_action :set_tenant, only: %i[update destroy]

  def new
    @tenant = Tenant.new
    @tenant.claim = @claim
  end

  def create
    @tenant = Tenant.new(tenant_params)
    @tenant.claim = @claim
    if @tenant.save
      redirect_to @tenant.claim
    else
      render "tenants/new"
    end
  end

  def update
    if @tenant.update(tenant_params)
      redirect_to @tenant.claim
    else
      redirect_to @tenant.claim, alert: "Tenant could not be updated."
    end
  end

  def destroy
    @tenant.destroy
    redirect_to @tenant.claim
  end

  private

  def set_claim
    @claim = Claim.find(params[:claim_id])
  end

  def set_tenant
    @tenant = Tenant.find(params[:id])
  end

  def tenant_params
    params.require(:tenant).permit(:user_id)
  end
end
