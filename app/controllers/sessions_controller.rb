# encoding: utf-8
class SessionsController < Devise::SessionsController
  def new
    @title = '登入'
    @seo_description = @title

    super
  end

  def create
    old_session = session.dup
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#new")
    sign_in(resource_name, resource)
    reset_session
    session.reverse_merge!(old_session)
    if mobile_device?
      redirect_to forum_path
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end

  private
  def after_sign_in_path_for(resource)
    forum_path
  end
end
