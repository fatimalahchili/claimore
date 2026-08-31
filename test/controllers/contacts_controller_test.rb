require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(email: "contact-#{SecureRandom.hex(4)}@example.com", password: "password")
    sign_in @user
    @property = Property.create!(address: "12 Example Street")
    Tenant.create!(user: @user, property: @property, role: :main_tenant, status: :tenant)
    @contact = Contact.create!(property: @property, name: "Alex Manager", role: "Property manager", email: "alex@example.com")
  end

  test "navbar destination renders the contacts index" do
    get contacts_url

    assert_response :success
    assert_select "h1", text: "Contacts"
    assert_select "a[href=?]", contact_path(@contact), text: /View contact/
  end

  test "renders new and show pages" do
    get new_contact_url
    assert_response :success

    get contact_url(@contact)
    assert_response :success
    assert_select "h1", text: "Alex Manager"
  end

  test "does not expose contacts from another property" do
    other_property = Property.create!(address: "99 Hidden Road")
    other_contact = Contact.create!(property: other_property, name: "Hidden Contact", role: "Landlord")

    get contact_url(other_contact)

    assert_response :not_found
  end
end
