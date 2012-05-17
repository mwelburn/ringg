class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @title = "All users"
    #TODO - need to paginate this based on params if available
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @user }
    end
    #TODO - show error message if it doesn't exist
  end

  def create
    #TODO - accept params, create a user, return success/error message - use devise?
    #@user = User.new(params[:user])
  end

  def fingers
    user = User.find(params[:id])
    @fingers = user.fingers.all
    #TODO - error if it doesn't exist
    respond_to do |format|
      format.html
      format.json { render :json => @fingers }
    end
  end
end