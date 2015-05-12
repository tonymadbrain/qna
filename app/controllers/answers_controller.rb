class AnswersController < ApplicationController
  before_action :load_answer, only: [:edit, :update, :destroy, :make_best, :render_answer, :render_error]
  before_action :load_question, only: [:create, :make_best, :update]
  before_action :check_user, only: [:update, :destroy]

  include PublicIndex
  include Voted

   def create
    @answer = @question.answers.build(answer_params)
    respond_to do |format|
      if @answer.save
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}", answer: @answer.to_json(include: :attachments), type: 'new'
          render nothing: true
        end
        format.json { render json: @answer.to_json(include: :attachments) }
      else
        format.js
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.js do
          PrivatePub.publish_to "/questions/#{@question.id}", answer: @answer.to_json(include: :attachments), type: "update"
          render nothing: true
        end
        format.json { render json: @answer.to_json(include: :attachments) }
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      end
    end    
  end

  def destroy
    @answer.destroy
  end

  def make_best
    @answer.make_best if @question.user_id == current_user.id
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

  def check_user
    render text: 'You do not have permission to view this page.', status: 403 if @answer.user_id != current_user.id
  end
end
