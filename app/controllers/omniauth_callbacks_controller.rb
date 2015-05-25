class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :main_function
  

  def facebook
  end

  def twitter
  end

  private

  def main_function
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #подтверждение мыла если что
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
    end
  end
end