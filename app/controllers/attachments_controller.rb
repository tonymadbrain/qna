class AttachmentsController < ApplicationController

  before_action :find_attachment
  
  def destroy
    if current_user.id == @attachment.attachable.user_id
      @attachment.destroy
    end
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
