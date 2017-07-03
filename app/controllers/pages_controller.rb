class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  
  def about
  end

  def no_search
  end
end
