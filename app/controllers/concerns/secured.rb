module Secured
  extend ActiveSupport::Concern

  included { before_action :logged_in_using_omniauth? }

  def logged_in_using_omniauth?
    return if session[:userinfo].present?
    redirect_to(root_path, alert: 'ログインしてください。')
  end
end
