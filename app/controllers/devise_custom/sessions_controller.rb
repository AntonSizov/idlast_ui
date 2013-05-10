class DeviseCustom::SessionsController < Devise::SessionsController
  def create
    current_user.update_attribute(:timezone, cookies["jstz_time_zone"])
    super
  end
end
