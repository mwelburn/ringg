class FingersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @fingers = Finger.all

    respond_to do |format|
      format.html
      format.json { render :json => @fingers }
    end
  end

  def show
    @finger = Finger.find(params[:id])
    #TODO - error if it doesn't exist
    respond_to do |format|
      format.html
      format.json { render :json => @finger }
    end
  end

  def update
    #TODO - must be the owner of this finger or an admin
    #@finger =
  end
end