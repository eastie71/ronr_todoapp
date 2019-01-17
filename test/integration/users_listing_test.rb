require 'test_helper'

class UsersListingTest < ActionDispatch::IntegrationTest
  def setup
    # Note: Only an ADMIN user can see the USERS list
    @aUser1 = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password", admin: true)
    @aUser2 = User.create!(name: "David", email: "dave@mail.com.au",
                    password: "password", password_confirmation: "password", admin: false)
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser1)
  end
  
  test "should get users index" do
    sign_in_as(@aUser1, @aUser1.password)
    get users_path
    assert_response :success
  end
  
  test "should reject non-admin user from access" do
    sign_in_as(@aUser2, @aUser2.password)
    get users_path
    assert_response :redirect
  end
  
  test "should get users list" do
    sign_in_as(@aUser1, @aUser1.password)
    get users_path
    assert_template 'users/index'
    # search for links to the specific users (td tags) - which are on the users lines
    assert_select "td", text: @aUser2.name
    assert_select "td", text: @aUser2.email
    # assert_select 'td', :text => 'fredddd'
  end
end
