class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, only: [:index]
  before_action :require_same_user_or_admin, only: [:edit, :show, :update, :destroy]
  
  def index
    # set an instance variable for the list of todos
    @todos = Todo.all
  end
  
  def new
    @todo = Todo.new
  end
  
  def create
    @todo = Todo.new(todo_params)
    @todo.user = current_user
    if @todo.save
      flash[:notice] = "Todo created successfully!"
      redirect_to todo_path(@todo)
    else
      render 'new'
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @todo.update(todo_params)
      flash[:notice] = "TODO was updated successfully"
      redirect_to todo_path(@todo)
    else
      render 'edit'
    end
  end
  
  def destroy
    @todo.destroy
    flash[:notice] = "TODO was deleted successfully"
    # Return to Listing page
    if logged_in? && current_user.admin?
      redirect_to todos_path
    else 
      redirect_to user_path(current_user)
    end
  end
  
  private
    def set_todo
      @todo = Todo.find(params[:id])
    end
    
    def todo_params
      params.require(:todo).permit(:name,:description)
    end
    
    def require_same_user_or_admin
      if !logged_in?
        flash[:danger] = "You cannot perform that action!"
        redirect_to root_path
      elsif current_user && current_user != @todo.user && !current_user.admin?
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