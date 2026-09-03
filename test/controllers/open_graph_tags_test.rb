require "test_helper"

class OpenGraphTagsTest < ActionDispatch::IntegrationTest
  test "renders an absolute og image url" do
    get root_url(host: "www.claim-ore.de", protocol: "https")

    assert_response :success
    assert_select "meta[property='og:image'][content='https://www.claim-ore.de/og-image.png']"
    assert_select "meta[property='og:image:width'][content='1200']"
    assert_select "meta[property='og:image:height'][content='630']"
    assert_select "meta[name='twitter:image:src'][content='https://www.claim-ore.de/og-image.png']"
  end

  test "og image has the required dimensions and stays under 1 megabyte" do
    image_path = Rails.root.join("public/og-image.png")
    image_data = image_path.binread
    width, height = image_data.byteslice(16, 8).unpack("NN")

    assert_equal [1200, 630], [width, height]
    assert_operator image_path.size, :<, 1.megabyte
  end
end
