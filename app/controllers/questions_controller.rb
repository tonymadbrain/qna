class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: :show
  before_action :check_user, only: :destroy
  after_action  :publish_question, only: :create

  respond_to :js, only: :update

  include PublicIndex
  include Voted

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
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

  def check_user
    render text: 'You do not have permission to view this page.', status: 403 if @question.user_id != current_user.id
  end

  def publish_question
    PrivatePub.publish_to("/questions", question: @question.to_json(include: :attachments)) if @question.valid?
  end
end
