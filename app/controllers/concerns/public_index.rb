module PublicIndex
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_user!, only: [:index, :show]
  end
end