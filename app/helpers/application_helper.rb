module ApplicationHelper

  ALERT_TYPES = [:error, :info, :success, :warning]

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

  def bootstrap_flash
    flash_messages = []
    flash.each do |type, message|
      # Skip empty messages, e.g. for devise messages set to nothing in a locale file.
      next if message.blank?

      type = :success if type == :notice
      type = :error   if type == :alert
      next unless ALERT_TYPES.include?(type)

      Array(message).each do |msg|
        text = content_tag(:div,
                           content_tag(:button, raw("&times;"), :class => "close", "data-dismiss" => "alert") +
                           msg.html_safe, :class => "alert fade in alert-#{type}")
        flash_messages << text if message
      end
    end
    flash_messages.join("\n").html_safe
  end

end
