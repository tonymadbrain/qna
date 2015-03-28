class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    #@question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
  end

  def edit
    
  end

  def update
    @answer.update(answer_params) if @answer.user_id == current_user.id
    @question = @answer.question
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:notice] = 'You cant delete this question.'
    end
    redirect_to @answer.question
  end

  private 
  
  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    #params.require(:answer).permit(:body)
    answer_params = params.require(:answer).permit(:body, :user_id)
    answer_params.merge( user_id: current_user.id )
  end
end
