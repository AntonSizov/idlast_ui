module ApplicationHelper

  # def logo
  #   image_tag("logo.png", :alt => "ShutterTracker", :class => "round")
  # end

  # Return a title on a per-page basis.
  def title
    base_title = "IDLast.com"
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end

end
