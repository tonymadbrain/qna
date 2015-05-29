class API::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!

  skip_before_action :authenticate_user!
  skip_authorization_check

  respond_to :json

  def index
    respond_with User.all_except current_resource_owner
  end

  def me
    respond_with current_resource_owner
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token   
  end
end