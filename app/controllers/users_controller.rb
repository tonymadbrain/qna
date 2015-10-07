class UsersController < ApplicationController
  before_action :load_user, only: :show
  skip_before_action :authenticate_user!
  skip_authorization_check

  def show
    respond_with(@user)
  end

  def index
    respond_with(@users = User.paginate(page: params[:page]).order('created_at DESC'))
  end

  private

  def load_user
    @user = User.find(params[:id])
    @user.rating = Rating.where(user_id: @user.id).count
  end
end
