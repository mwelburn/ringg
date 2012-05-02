# https://github.com/plataformatec/devise/wiki/How-To:-Make-Devise-work-with-other-formats-like-mobile,-iphone-and-ipad-(Rails-specific)

ActionController::Responder.class_eval do
  alias :to_ios :to_html
end