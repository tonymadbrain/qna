class AnswersController < ApplicationController
  before_action :load_answer, only: [:edit, :update, :destroy, :make_best, :render_answer, :render_error, :show]
  before_action :load_question, only: [:create, :make_best, :update]
  before_action :answer_owner, only: [:update, :destroy]
  before_action :question_owner, only: :make_best
  after_action  :publish_answer, only: :create

  authorize_resource

  respond_to :js, only: [:destroy, :make_best, :create, :update]

  include PublicIndex
  include Voted

  def create
    respond_with(@answer = @question.answers.create(answer_params))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def make_best
    respond_with(@answer.make_best)
  end

  private

  def load_question
    @question = if params.key?(:question_id)
                  Question.find(params[:question_id])
    else
      @answer.question
    end
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    answer_params = params.require(:answer).permit(:body, :user_id, attachments_attributes: [:id, :file, :_destroy])
    answer_params.merge(user_id: current_user.id)
  end

  def answer_owner
    render text: 'You do not have permission to view this page.', status: 403 if @answer.user_id != current_user.id
  end

  def question_owner
    render text: 'You do not have permission to view this page.', status: 403 if @question.user_id != current_user.id
  end
  
  def publish_answer
    PrivatePub.publish_to("/questions/#{@question.id}", answer: @answer.to_json(include: :attachments), author: @answer.user_id) if @answer.valid?
  end
end
