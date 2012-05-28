class FingersController < ApplicationController
  before_filter :authenticate_user!

  #TODO-will this actually get invoked?
  def index
    @fingers = Finger.all

    respond_to do |format|
      format.html
      format.json { render :json => @fingers }
    end
  end

  #TODO-will this actually get invoked?
  def show
    @finger = Finger.find(params[:id])
    #TODO - error if it doesn't exist
    respond_to do |format|
      format.html
      format.json { render :json => @finger }
    end
  end

  #TODO - figure out all these redirects
  def update
    #TODO - must be the owner of this finger or an admin -- implement via CanCan later
    @finger = Finger.find(params[:finger])

    if @finger.user_id == current_user.id
      @finger.size = params[:finger][:size]
      @finger.comment = params[:finger][:comment]
      #ignore any other attempts to set values

      if @finger.save
        render :json => @finger
      else
        render :json => { :errors => @finger.errors.full_messages }, :status => 422
      end
    else
      render :json => { :errors => "No access to this user"}, :status => 422
    end
  end
end