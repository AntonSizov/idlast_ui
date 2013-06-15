class ApplicationController < ActionController::Base
  before_filter :redirect_to_microstock
  before_filter :set_timezone
  protect_from_forgery

  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

    def set_timezone
      if current_user
        Time.zone = current_user.timezone
      elsif jstz_time_zone = cookies["jstz_time_zone"]
        Time.zone = jstz_time_zone
      else
        Time.zone = config.time_zone
      end
    end

    def redirect_to_microstock
      request_uri = env["REQUEST_URI"]
      redirect_to_uri = request_uri.sub('idlast.com', 'idlast.microstock.ru')
      redirect_to redirect_to_uri if request.host == 'idlast.com'
    end

  # def deny_access
  #   respond_to do |format|
  #     format.html { redirect_to root_path, :alert => ("Access denied") }
  #     format.json {
  #       render :json => { :success => false, :msg => ("Access denied") }
  #     }
  #     # format.html { redirect_to root_path, :alert => t(:access_denied) }
  #     # format.json {
  #     #   render :json => { :success => false, :msg => t(:access_denied) }
  #     # }
  #   end

end
