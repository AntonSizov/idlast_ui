module ApplicationHelper

  def title
    base_title = "IDLast.com"
    if @title.nil?
      base_title
    else
      "#{@title} | #{base_title}"
    end
  end

  def li_link_to(title, path)
    # path is path of nav item, i.e. /articles for articles resource
    # active = { class: "active" } if request.fullpath.index(path)
    active = { class: "active" } if current_page?(path)
    content_tag(:li, link_to(title, path), active)
  end

  def admin_ns?
    controller.class.name.split("::").first=="Admin"
  end

end
