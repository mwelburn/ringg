class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  #TODO - add this back in
  #before_filter :adjust_format_for_iphone

  private
    def adjust_format_for_iphone
      request.format = :ios if ios_user_agent?
    end

    def ios_user_agent?
      request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
    end
end
