class ContactsController < ApplicationController
  before_action :set_contact, only: %i[show edit update destroy]

  def index
    @contacts = contacts_scope.order(:name)
  end

  def show
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_attributes)
    if @contact.save
      redirect_to @contact, notice: "Contact was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @contact.update(contact_attributes)
      redirect_to @contact, notice: "Contact was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path, notice: "Contact was successfully deleted."
  end

  private

  def set_contact
    @contact = contacts_scope.find(params[:id])
  end

  def contacts_scope
    Contact.where(property: current_user.properties)
  end

  def contact_attributes
    contact_params.except(:property_id).merge(
      property: current_user.properties.find(contact_params[:property_id])
    )
  end

  def contact_params
    params.require(:contact).permit(:property_id, :name, :role, :email, :address, :phone_number, :website)
  end
end
