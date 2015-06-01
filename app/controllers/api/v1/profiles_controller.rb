class API::V1::ProfilesController < API::V1::BaseController
  skip_before_action :authenticate_user!

  authorize_resource

  def index
    respond_with User.all_except current_resource_owner
  end

  def me
    respond_with current_resource_owner
  end
end