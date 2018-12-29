require 'test_helper'

class TodosEditTest < ActionDispatch::IntegrationTest
  def setup
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description")
  end
  
  test "should edit valid todo successfully" do
    get todo_path(@aTodo)
    assert_template 'todos/show'
    # Check there is a Edit button link
    assert_select 'a[href=?]', edit_todo_path(@aTodo), text: "Edit"
    get edit_todo_path(@aTodo)
    updated_todo_name = "UPDATED todo name"
    updated_todo_desc = "UPDATED todo description"
    patch todo_path(@aTodo), params: {todo: {name: updated_todo_name, description: updated_todo_desc}}
    assert_redirected_to @aTodo
    # Check there is a flash message after edit OK  
    assert_not flash.empty?
    @aTodo.reload
    assert_match @aTodo.name, updated_todo_name
    assert_match @aTodo.description, updated_todo_desc
  end
  
  test "should fail to edit invalid todo" do
    get edit_todo_path(@aTodo)
    # Try to update an empty todo
    patch todo_path(@aTodo), params: {todo: {name: " ", description: " "}}
    # Should remain on the edit template
    assert_template 'todos/edit'
    # Make sure there is a h2 element with the word errors in it
    assert_select 'h2', :text => /errors/
  end
end