require 'test_helper'

class TodosTest < ActionDispatch::IntegrationTest
  def setup
    # Note: Only an ADMIN user can see the FULL todos list
    @aUser = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password", admin: true)
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser)
  end
  
  
  test "should get todos index" do
    sign_in_as(@aUser, @aUser.password)
    get todos_path
    assert_response :success
  end
  
  test "should get todos list" do
    sign_in_as(@aUser, @aUser.password)
    get todos_path
    assert_template 'todos/index'
    # search for links to the specific todo items (td tags) - which are on the todo lines
    assert_select "td", text: @aTodo.name
    assert_select "td", text: @aTodo.description
    # assert_select 'td', :text => 'fredddd'
  end
  
  test "should show the todo" do
    sign_in_as(@aUser, @aUser.password)
    get todo_path(@aTodo)
    assert_template 'todos/show'
    # search for the todo name and description in the body
    assert_match @aTodo.name, response.body
    assert_match @aTodo.description, response.body
    # there should be an Edit and Return to listing links
    assert_select 'a[href=?]', edit_todo_path(@aTodo), text: "Edit"
    assert_select 'a[href=?]', todos_path, text: "Return to ALL Listing"
  end
  
  test "create new valid todo" do
    sign_in_as(@aUser, @aUser.password)
    get new_todo_path
    assert_template 'todos/new'
    my_todo_name = "my new todo item"
    my_todo_desc = "my description of todo"
    # Check to see if count of todo increases after posting valid todo
    assert_difference 'Todo.count' do
      post todos_path, params: { todo: {name: my_todo_name, description: my_todo_desc, user: @aUser}}
    end
    # After successful post should follow the redirect to the SHOW page
    follow_redirect!
    assert_match my_todo_name, response.body
    assert_match my_todo_desc, response.body
  end
  
  test "reject invalid new todo" do
    sign_in_as(@aUser, @aUser.password)
    get new_todo_path
    assert_template 'todos/new'
    my_todo_name = "valid todo name"
    my_invalid_todo_desc = ""
    # Make sure count does not increase after attempting to post invalid todo
    assert_no_difference 'Todo.count' do
      post todos_path, params: { todo: {name: my_todo_name, description: my_invalid_todo_desc}}
    end
    assert_template 'todos/new'
    # Make sure there is a h5 element and it has the word "errors" in its content
    assert_select 'h5', :text => /error/
  end
end
