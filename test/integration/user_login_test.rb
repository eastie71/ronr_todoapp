require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(name: "Craig Eastwood", email: "craig@test.com", password: "password")
  end
  
  test "reject invalid login" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: " ", password: " " } }
    assert_template 'sessions/new'
    # Should get a fail error message
    assert_not flash.empty?
    # Check that there is a login path option still available and there is NOT a logout path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    # Fail message should clear after going to root path
    get root_path
    assert flash.empty?
  end
  
  test "accept valid login and start session" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: @user.email, password: @user.password } }
    follow_redirect!
    # Check that there is a logout path option available and there is NOT a login path
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", login_path, count: 0
    # Also Check that there is an edit path for the current user
    assert_select "a[href=?]", edit_user_path(@user)
    assert_template 'users/show'
    assert_not flash.empty?
  end
end
