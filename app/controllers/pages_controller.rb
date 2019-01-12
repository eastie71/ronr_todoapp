class PagesController < ApplicationController
  def home
    redirect_to current_user if logged_in?
  end
  def about
  end
  def help
  end
end