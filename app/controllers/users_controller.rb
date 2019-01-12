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
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end
  
  def show
    @user = User.find(params[:id])
    @user_todos = @user.todos
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully."
      # Go the user SHOW page
      redirect_to @user
    else
      if @user.errors.any?
        puts "Had Errors!"
        @user.errors.full_messages.each do |msg|
          puts msg
        end
      else
        puts "NO Errors"
      end
   
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end