class AttachmentsController < ApplicationController
  before_action :find_attachment, only: :destroy

  authorize_resource

  respond_to :js, only: :destroy

  def destroy
    respond_with(@attachment.destroy) if current_user.id == @attachment.attachable.user_id
  end

  private

  def find_attachment
    @attachment = Attachment.find(params[:id])
  end
end
