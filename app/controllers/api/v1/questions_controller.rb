class API::V1::QuestionsController < API::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show, :create]

  authorize_resource

  def index
    @questions= Question.all
    respond_with @questions, each_serializer: QuestionsListSerializer
    # respond_with @questions #, each_serializer: QuestionsListSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  def create
    respond_with @question = current_resource_owner.questions.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end