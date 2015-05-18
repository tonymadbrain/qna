class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action  :publish_question, only: :create

  respond_to :html
  respond_to :js, only: :create

  include PublicIndex
  include Voted

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    # respond_with(@question = current_user.questions.new(question_params))
    respond_with(@question = Question.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy) if @question.user_id == current_user.id
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to("/questions", question: @question.to_json(include: :attachments), data: 'question') if @question.valid?
  end
end
