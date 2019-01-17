require 'test_helper'

class UserDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @aUser1 = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password", admin: true)
    @aUser2 = User.create!(name: "Craig2", email: "cde2@mail.com.au",
                    password: "password", password_confirmation: "password", admin: false)
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser1)
  end
  
  test "admin user should delete user successfully" do
    sign_in_as(@aUser1, @aUser1.password)
    get users_path
    assert_select 'a[href=?]', user_path(@aUser2), text: "Delete"
    # Check that count decreases by 1 on delete
    assert_difference 'User.count', -1 do
      delete user_path(@aUser2)
    end
    # Should flash a success message
    assert_not flash.empty?
  end
  
  test "non-admin user should fail to delete user" do
    sign_in_as(@aUser2, @aUser2.password)
    assert_no_difference 'User.count' do
      delete user_path(@aUser1)
    end
    # Should flash a fail message
    assert_not flash.empty?
  end
  
  test "admin user should fail to delete themselves" do
    sign_in_as(@aUser1, @aUser1.password)
    assert_no_difference 'User.count' do
      delete user_path(@aUser1)
    end
    # Should flash a fail message
    assert_not flash.empty?
  end
end
