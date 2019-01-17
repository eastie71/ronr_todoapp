class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_same_user_or_admin, only: [:edit, :show, :update]
  before_action :require_admin, only: [:destroy, :index]
  
  def new
    if current_user
      flash[:danger] = "You are already logged in. Logout if you wish to Signup again"
      redirect_to user_path(current_user)
    end
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
  
  def index
    @users = User.all
  end
  
  def show
    @user_todos = @user.todos
  end
  
  def edit
  end
  
  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated successfully."
      # Go the user SHOW page
      redirect_to @user
    else
      @user.reload
      render 'edit'
    end
  end
  
  def destroy
    if current_user != @user
      user_name = @user.name
      @user.destroy
      flash[:notice] = "User: \"" + user_name + "\" was deleted successfully"
      # Return to User Listing page
      redirect_to users_path
    else
      flash[:danger] = "You cannot delete your own account"
      redirect_to users_path
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def require_same_user_or_admin
      if !logged_in?
        flash[:danger] = "You cannot perform that action!"
        redirect_to root_path
      elsif current_user && current_user != @user && !current_user.admin?
        flash[:danger] = "You can only view or modify your own account!"
        redirect_to user_path(current_user)
      end
    end
  
    def require_admin
      if !logged_in?
        flash[:danger] = "You cannot perform that action!"
        redirect_to root_path
      elsif current_user && !current_user.admin?
        flash[:danger] = "Only admin users can perform this action"
        redirect_to root_path
      end
    end
end