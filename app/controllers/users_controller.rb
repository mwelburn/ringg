class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [ :show ]
  before_filter :load_user, :only => [ :show, :fingers ]

  def index
    @title = "All users"
    #TODO - need to paginate this based on params if available...or scrolling
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render :json => @users }
    end
  end

  def show
    @fingers = @user.fingers.all
    respond_to do |format|
      format.html
      format.json { render :json => { :user => @user, :fingers => @fingers } }
    end
  end

  #TODO - implement later
  def create
    #TODO - accept params, create a user, return success/error message - use devise?
    #@user = User.new(params[:user])
  end

  def fingers
    @fingers = @user.fingers.all
    respond_to do |format|
      format.html { redirect_to @user}
      format.json { render :json => @fingers }
    end
  end

  #TODO - remove this, unnecessary -- require update one by one
  def update_fingers
    fingers = params[:fingers]
    begin
      fingers.each do |finger|
        #TODO - use CanCan for this later
        if (finger.user_id == current_user.id)
          begin
            myfinger = current_user.fingers.find(finger.id)
          rescue
            format.json { render :json => { :errors => "Finger does not exist for user"}, :status => 422 }
          end

          myfinger.size = finger.size
          myfinger.comment = finger.comment
          myfinger.save
        end
      end
    rescue ActiveRecord::RecordInvalid => invalid
      format.json { render :json => { :errors => "Finger cannot be updated: #{invalid}"}}
    end

    render :json => { :fingers => @user.fingers }
  end

  private
    def load_user
      begin
        @user = User.find(params[:id])
      rescue
        respond_to do |format|
          format.html { redirect_to error_path, :flash => { :failure => "User does not exist"} }
          format.json { render :json => { :errors => "User does not exist"}, :status => 422 }
        end
      end
    end
end