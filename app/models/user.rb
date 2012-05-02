class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  #TODO - is this where facebook_id and twitter_id should be? they should only be created, never updated
  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :username, :email, :password, :password_confirmation, :remember_me, :facebook_id, :twitter_id
  # attr_accessible :title, :body

  validates :username, :presence => true,
                       :length => { :maximum => 20 },
                       :uniqueness => true,
                       :format => { :with => /^\w+$/,
                                    :message => "can only contain letters, numbers, and underscores"
                                  }

  validates :name, :length => { :maximum => 50 }

  default_scope :order => 'users.created_at DESC'

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:facebook_id => data.id).first
      user
    else # Create a user with a stub password.
      #TODO - make sure to handle username not existing (does it exist in the data?)
      User.create!(:email => data.email, :name => data.name, :username => data.username, :facebook_id => data.id, :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    if user = User.where(:twitter_id => data.id).first
      user
    else # Create a user with a stub password.
      logger.debug data
      #need to have a followup page that asks for an email?
      User.create!(:email => data.email, :name => data.name, :username => data.screen_name, :twitter_id => data.id, :password => Devise.friendly_token[0,20])
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        #Currently do nothing. Maybe in the future we can keep information up to date (email,name,username/vanity)
        #assume whatever they start with, they might modify here to customize and we don't want to overwrite
      elsif data = session["devise.twitter_data"] && session["devise.twitter_data"]["extra"]["raw_info"]
        #Currently do nothing. Maybe in the future we can keep information up to date (email,username)
        #assume whatever they start with, they might modify here to customize and we don't want to overwrite
      end
    end
  end
end
