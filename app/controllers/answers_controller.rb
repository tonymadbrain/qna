class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_answer, only: [:edit, :update, :destroy, :make_best, :load_question]
  before_action :load_question
  before_action :check_user, only: [:update, :destroy]

  def create
    @answer = @question.answers.create(answer_params)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
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
    answer_params = params.require(:answer).permit(:body, :user_id)
    answer_params.merge(user_id: current_user.id)
  end

  def check_user
    render text: 'You do not have permission to view this page.', status: 403 if @answer.user_id != current_user.id
  end
end
