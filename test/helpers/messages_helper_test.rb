require "test_helper"

class MessagesHelperTest < ActionView::TestCase
  test "markdown_message renders markdown and strips unsafe html" do
    html = markdown_message("**Important**\n\n- First\n- Second\n\n<script>alert('x')</script>")

    assert_includes html, "<strong>Important</strong>"
    assert_includes html, "<ul>"
    assert_includes html, "<li>First</li>"
    assert_not_includes html, "<script>"
    assert_not_includes html, "alert"
  end
end
