class ApplicationController < ActionController::Base
  # by defining as helper methods they become available in the views (not just the controllers)
  helper_method :current_user, :logged_in?
  
  def current_user
    # ruby always returns the last line from a method
    # this means return the @current_chef if it exists, else go and find it if it doesn't
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    # by using the '!!' this will convert the return of any function to a true/false
    !!current_user
  end
  
  def require_user
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end
end
