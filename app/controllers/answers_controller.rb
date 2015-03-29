class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy]
  before_action :check_user, only: [:update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.create(answer_params)
  end

  def edit
    
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private 
  
  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    answer_params = params.require(:answer).permit(:body, :user_id)
    answer_params.merge( user_id: current_user.id )
  end

  def check_user
    render text: 'You do not have permission to view this page.', status: 403 if @answer.user_id != current_user.id
  end
end
