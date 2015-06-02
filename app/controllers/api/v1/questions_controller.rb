class API::V1::QuestionsController < API::V1::BaseController
  skip_before_action :authenticate_user!, only: [:index, :show]

  authorize_resource

  def index
    @questions= Question.all
    respond_with @questions, each_serializer: QuestionsListSerializer
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end