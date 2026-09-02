class User < ApplicationRecord
  attr_accessor :property_address, :property_moved_on

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :tenants, dependent: :destroy
  has_many :properties, through: :tenants
  has_many :claims, -> { distinct }, through: :properties
  has_many :chats, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_initial_property, if: :property_address_present?

  private

  def property_address_present?
    property_address.present?
  end

  def create_initial_property
    property = Property.create!(address: property_address, moved_on: property_moved_on)
    tenants.create!(property: property, role: :main_tenant, status: :added)
  end
end
