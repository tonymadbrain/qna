class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :main_function
  
  def facebook
  end

  def twitter
  end

  private

  def main_function
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session['devise.identity_id'] = @user.identitys.first.id
      redirect_to new_user_registration_url
    end
  end
end