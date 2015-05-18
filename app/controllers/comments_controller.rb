class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create

  def create
    @comment = @commentable.comments.build(comments_params.merge(user_id: current_user.id))
    if @comment.save
      respond_to do |format|
        format.js  do
          PrivatePub.publish_to "/questions/#{@commentable.try(:question).try(:id) || @commentable.id}", comment: @comment.to_json, user: @comment.user.to_json, data: 'comment' 
          render nothing: true
        end
      end
    else
      format.json { render json: @comment.errors.full_messages, status: :unprocessable_entity }
    end
  end

  private

  def load_commentable
    parameter = (params[:commentable].singularize + '_id').to_sym
    @commentable = params[:commentable].classify.constantize.find(params[parameter])
    puts @commentable
  end

  def comments_params
    params.require(:comment).permit(:body)
  end
end
