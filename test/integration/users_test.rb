require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  def setup
    @aUser = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser)
  end
  
  test "should get user signup path" do
    get signup_path
    assert_response :success
  end
  
  test "reject an invalid signup" do
    get signup_path
    assert_template 'users/new'
    # Check to see if the count of the number of users increases, when trying to post an invalid user
    assert_no_difference 'User.count' do
      post users_path, params: { user: {name: " ", email: " ", password: "password", password_confirmation: " "}}
    end
    assert_template 'users/new'
    # Check for card-header and card-body in the HTML - this will appear if any errors occur
    assert_select "h5.card-header"
    assert_select "div.card-body"
  end
  
  test "accept and create a valid signup account" do
    get signup_path
    assert_template 'users/new'
    # Check to see if the count of the number of users increases, when trying to post a valid user
    assert_difference 'User.count' do
      post users_path, params: { user: {name: "Craig", email: "craig@test.com", password: "password", password_confirmation: "password"}}
    end
    # Should go to show page after create
    follow_redirect!
    assert_template 'users/show'
    # Check for flash message of successful create
    assert_not flash.empty?
  end
end
