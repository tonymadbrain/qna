module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_voted, only: [:create_vote, :delete_vote]
  end

  def create_vote
    authorize! :create_vote, @resource
    @vote = @resource.vote(current_user, params[:value])
    respond_to do |format|
      format.json { render json: {resource: @resource, total: @resource.total_votes, class: @resource.class.name} }
    end
  end

  def delete_vote
    authorize! :delete_vote, @resource
    @resource.disvote(current_user)
    respond_to do |format|
      format.json { render json: {resource: @resource, total: @resource.total_votes, class: @resource.class.name} }
    end
  end

  private

  def find_voted
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def user_can_not_vote_for_his_resource
    if @resource.user_id == current_user.id
      render status: 403, text: "Author can't vote for his answer or question"
    end
  end

  def author_of_vote
    unless @resource.voted_by?(current_user)
      render status: 403, text: "You can't deny someone else's vote"
    end
  end

  def user_can_not_vote
    if @resource.voted_by?(current_user)
      render status: 403, text: "You've already voted for this answer or question"
    end
  end
end