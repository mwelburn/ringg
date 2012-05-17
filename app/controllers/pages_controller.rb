class PagesController < ApplicationController

  def index
    @title = "Keep track of your ring sizes"
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