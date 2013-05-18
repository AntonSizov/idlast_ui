class DeviseCustom::SessionsController < Devise::SessionsController
  def create
    if current_user
      current_user.update_attribute(:timezone, cookies["jstz_time_zone"])
    end
    super
  end
end
