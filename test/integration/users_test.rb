require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  def setup
    @aUser = User.create!(name: "Craig", email: "cde@mail.com.au",
                    password: "password", password_confirmation: "password")
    @aTodo = Todo.create!(name: "testing todo name", description: "testing todo description", user: @aUser)
  end
end
