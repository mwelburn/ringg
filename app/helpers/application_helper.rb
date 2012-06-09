module ApplicationHelper
  def title
    base_title = "Ringg Me"
    if @title.nil?
      "#{base_title} | Set your ring sizes
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag("logo.png", :alt => "Ringg Me", :class => "round")
  end
end
