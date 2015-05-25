class RegistrationsController < Devise::RegistrationsController

  def create
    identity_id = session['devise.identity_id']
    identity = identity_id.present? ? Identity.find(identity_id) : nil
    if identity.present?
      user = User.find_by(email: sign_up_params[:email])
      if user.present?
        identity.update!(confirm_code: SecureRandom.hex, email: user.email)
        IdentityMailer.confirm_email(user, identity).deliver_now
        redirect_to identity_path(identity)
        return
      end
    end

    super

    identity.update!(user: resource) if identity.present? && resource.persisted?
  end
  
  private
  
  def build_resource(hash=nil)
    super
    self.resource.without_password = true if session['devise.identity_id'].present?
  end
end