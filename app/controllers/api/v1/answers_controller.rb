class API::V1::AnswersController < API::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show, :create]
  before_action :find_question, except: :show

  authorize_resource

  def index
    respond_with @question.answers
  end

  def show
    @answer = Answer.find(params[:id])
    respond_with @answer
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user_id: current_resource_owner.id))
    respond_with @answer
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end