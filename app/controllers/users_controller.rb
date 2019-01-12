class UsersController < ApplicationController
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # Set the NEW user as the current logged in user
      session[:user_id] = @user.id
      flash[:success] = "Welcome #{@user.name} to the TODO List App!"
      #redirect_to user_path(@user)
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @user_todos = @user.todos
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end