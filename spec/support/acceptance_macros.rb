module AcceptanceMacros
  def log_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within ".actions" do
      click_on 'Sign in'
    end
  end

  def sign_up(user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
  end

  def sign_in_soc_network(soc_network, options)
    OmniAuth.config.mock_auth[soc_network] = nil
    OmniAuth.config.add_mock(soc_network, options)
  end
end
