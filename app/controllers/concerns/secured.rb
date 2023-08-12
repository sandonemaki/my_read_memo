module Secured
  extend ActiveSupport::Concern

  included { before_action :logged_in_using_omniauth? }

  def logged_in_using_omniauth?
    redirect_to '/' unless session[:userinfo].present?
  end
end
