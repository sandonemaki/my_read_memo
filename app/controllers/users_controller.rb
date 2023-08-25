class UsersController < ApplicationController
  include Secured

  def account_setting
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_email = user_info['name']
    account_setting_view_models = ViewModel::AccountSetting.new(user: user, user_email: user_email)
    render('account_setting', locals: { user: account_setting_view_models })
  end

  def account_update
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    auth0_id = user_info['sub']
    user = User.find_or_initialize_by(auth0_id: auth0_id)
    current_email = user_info['name']
    new_email = account_params[:email]
    new_nickname = account_params[:nickname]

    user_email = current_email if current_email == new_email
    if current_email != new_email
      response = Auth0UserUpdater.update_name(new_email: new_email, auth0_id: auth0_id)
      if response != nil
        user_email = response
      else
        user_email = current_email
        flash[:error] = 'emailが更新できませんでした'
      end
    end

    if user.nickname != new_nickname
      user.nickname = new_nickname
      user.save
    end

    account_setting_view_models = ViewModel::AccountSetting.new(user: user, user_email: user_email)
    render('account_setting', locals: { user: account_setting_view_models })
  end

  def account_params
    params.permit(:nickname, :email)
  end
end
