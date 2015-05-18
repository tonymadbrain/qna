class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  include PublicIndex
  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
      PrivatePub.publish_to "/questions", question: @question.to_json(include: :attachments), data: 'question'
    else
      flash[:notice] = 'You must fill all fields.'
      render :new
    end
  end

  def update
    @question.update(question_params)
  end

  def destroy
    if @question.user_id == current_user.id
      @question.destroy
      flash[:notice] = 'You question successfully deleted.'
    else
      flash[:notice] = 'You cant delete this question.'
    end
    redirect_to questions_path
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
