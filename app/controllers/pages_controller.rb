class PagesController < ApplicationController

  def index
    if user_signed_in?
      redirect_to current_user
    else
      @title = "Keep track of your ring sizes"
    end
  end

  def contact
    @title = "Contact"
  end

  def about
    @title = "About"
  end

  def help
    @title = "Help"
  end

  def error
    @title = "Page Not Found"
  end
end