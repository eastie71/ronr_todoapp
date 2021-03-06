require 'test_helper'

class TodosDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @aUser = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser)
  end
  
  test "should delete todo successfully" do
    sign_in_as(@aUser, @aUser.password)
    get user_path(@aUser)
    assert_select 'a[href=?]', todo_path(@aTodo), text: "Delete"
    # Check that count decreases by 1 on delete
    assert_difference 'Todo.count', -1 do
      delete todo_path(@aTodo)
    end
    # Should flash a success message
    assert_not flash.empty?
  end
end
