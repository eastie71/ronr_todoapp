require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @aUser = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @admin_user = User.create!(name: "Admin", email: "admin@mail.com.au",
                    password: "password", password_confirmation: "password", admin: true)
    @non_admin_user = User.create!(name: "NonAdmin", email: "nonadmin@mail.com.au",
                    password: "password", password_confirmation: "password", admin: false)
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser)
  end
  
  test "accept and save a valid user edit" do
    sign_in_as(@aUser, @aUser.password)
    get edit_user_path(@aUser)
    assert_template 'users/edit'
    patch user_path(@aUser), params: { user: {name: "Craig2", email: "cde2@mail.com.au"} }
    
    # Should go to show page after edit
    assert_redirected_to @aUser
    # Check for flash message of successful edit
    assert_not flash.empty?
    @aUser.reload
    assert_match "Craig2", @aUser.name
    assert_match "cde2@mail.com.au", @aUser.email
  end
  
  test "accept edit by admin user" do
    sign_in_as(@admin_user, @admin_user.password)
    get edit_user_path(@aUser)
    assert_template 'users/edit'
    patch user_path(@aUser), params: { user: {name: "Craig2", email: "cde2@mail.com.au"} }
    # Should go to show page after edit
    assert_redirected_to @aUser
    # Check for flash message of successful edit
    assert_not flash.empty?
    @aUser.reload
    assert_match "Craig2", @aUser.name
    assert_match "cde2@mail.com.au", @aUser.email
  end
end
