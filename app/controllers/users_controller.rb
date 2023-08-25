class UsersController < ApplicationController
  include Secured

  def account_setting
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_email = session[:userinfo][:email]

    account_setting_view_models = ViewModel::AccountSetting.new(user: user, user_email: user_email)
    render('account_setting', locals: { user: account_setting_view_models })
  end
end
