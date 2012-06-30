class FingersController < ApplicationController
  before_filter :authenticate_user!, :only => [ :update ]
  before_filter :load_user, :only => [ :index, :show ]

  def index
    @fingers = @user.fingers.all
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :json => @fingers }
    end
  end

  #TODO-will this actually get invoked?
  def show
    @finger = @user.fingers.find_by_side_and_digit(params[:side], params[:digit])
    #TODO - error if it doesn't exist
    respond_to do |format|
      format.html { redirect_to @user }
      format.json { render :json => @finger }
    end
  end

  #TODO - figure out all these redirects
  def update
    #TODO - must be the owner of this finger or an admin -- implement via CanCan later
    @finger = Finger.find(params[:id])

    if @finger.user_id == current_user.id
      @finger.size = params[:size] unless params[:size].nil?
      @finger.comment = params[:comment] unless params[:comment].nil?
      #ignore any other attempts to set values

      begin
        @finger.save!
        render :json => @finger
      rescue
        render :json => { :errors => @finger.errors.full_messages }, :status => 422
      end
    else
      render :json => { :errors => "No access to this user"}, :status => 422
    end
  end

  private
    def load_user
      begin
        @user = User.find(params[:user_id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist"} }
          format.json { render :json => { :errors => "User does not exist"}, :status => 422 }
        end
      end
    end
end