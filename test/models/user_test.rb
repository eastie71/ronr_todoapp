require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: "Craig", email: "craig@mail.com", password: "password", password_confirmation: "password")
  end
  
  test "User should be valid" do
    assert @user.valid?
  end
  
  test "Email cannot be blank" do
    @user.email = ""
    assert_not @user.valid?
  end
  
  test "Name cannot be blank" do
    @user.name = ""
    assert_not @user.valid?
  end
  
  test "Name less than max length" do
    @user.name = "A" * 81
    assert_not @user.valid?
  end
  
  test "email should accept correct email addresses" do
    valid_emails = %w[craig@example.com abc.123@fred.com.au whatthe+f@test.org.uk jj.kk@sfx.vic.gov.edu.au]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end
  
  test "email should reject invalid email addresses" do
    invalid_emails = %w[craig@example abc.123@@fred.com.au whatthe+f#test.org.uk jj.kk@sfx.vic. wow@foo+bar.com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end
  
  test "email should be unique and case insensitive" do
    user_copy = @user.dup
    user_copy.email = @user.email.upcase
    assert_not user_copy.valid?
  end
  
  test "password cannot be blank" do
    @user.password = " "
    assert_not @user.valid?
  end
  
  test "password must be min length" do
    @user.password = "1234"
    assert_not @user.valid?
  end
  
  test "todos_are_deleted_on_user_delete" do
    @user.todos.create!(name: "my todo name", description: "my todo desc")
    assert_difference 'Todo.count', -1 do
      @user.destroy
    end
  end
  
  test "valid password is accepted" do
    @user.password = @user.password_confirmation = "new_password"
    assert @user.valid?
  end
end
