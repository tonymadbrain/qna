class IdentitiesController < ApplicationController
  before_action :load_identity, only: [:show, :confirm]

  def show
    render nothing: true unless @identity.confirm_code.present?
  end

  def confirm
    if @identity.confirm_code == params[:confirm_code]
      user = User.find_by(email: @identity.email)
      return unless user
      @identity.update!(user: user, confirm_code: nil, email: nil)
      sign_in_and_redirect user, event: :authentication
      flash[:notice] = "Successfully authenticated from #{@identity.provider.capitalize} account" if is_navigational_format?
    end
  end

  private
    def load_identity
      @identity = Identity.find(params[:id])
    end
end