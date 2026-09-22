require "application_system_test_case"

class RoomsTest < ApplicationSystemTestCase
  test "visiting the rooms page" do
    visit rooms_url

    assert_selector "h1", text: "Rooms"
  end
end