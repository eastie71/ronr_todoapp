class TodosController < ApplicationController
  def index
    # set an instance variable for the list of todos
    @todos = Todo.all
  end
  
  def new
    @todo = Todo.new
  end
  def create
    @todo = Todo.new(todo_params)
    
    if @todo.save
      flash[:notice] = "Todo created successfully!"
      redirect_to todo_path(@todo)
    else
      render 'new'
    end
  end
  def show
    @todo = Todo.find(params[:id])
  end
  def edit
    @todo = Todo.find(params[:id])
  end
  def update
    @todo = Todo.find(params[:id])
    if @todo.update(todo_params)
      flash[:notice] = "TODO was updated successfully"
      redirect_to todo_path(@todo)
    else
      render 'edit'
    end
  end
  
  private
    def todo_params
      params.require(:todo).permit(:name,:description)
    end
end