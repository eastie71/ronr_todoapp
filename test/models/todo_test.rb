require 'test_helper'

class TodoTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Craig", email: "craig@mail.com", password: "password", password_confirmation: "password")
    @todo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @user)
  end
  
  test "todo without user should be invalid" do
    @todo.user_id = nil
    assert_not @todo.valid?
  end
  
  test "todo should be valid" do
    assert @todo.valid?
  end
  
  test "todo name cannot be blank" do
    @todo.name = ""
    assert_not @todo.valid?
  end
  
  test "todo description cannot be blank" do
    @todo.description = ""
    assert_not @todo.valid?
  end
end