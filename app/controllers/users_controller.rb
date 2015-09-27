class UsersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def show
  end

  def index
    respond_with(@users = User.paginate(page: params[:page]).order('created_at DESC'))
  end
end
