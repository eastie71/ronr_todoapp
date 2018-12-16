require 'test_helper'

class TodosTest < ActionDispatch::IntegrationTest
  def setup
    @aTodo = Todo.create!(name: "testing todo name", description: "testing tod description")
  end
  
  
  test "should get todos index" do
    get todos_path
    assert_response :success
  end
  
  test "should get todos list" do
    get todos_path
    assert_template 'todos/index'
    # search for links to the specific todo items (td tags) - which are on the todo lines
    assert_select "td", text: @aTodo.name
    assert_select "td", text: @aTodo.description
    # assert_select 'td', :text => 'fredddd'
  end
end
