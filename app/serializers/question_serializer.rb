class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :comments
  has_many :attachments
end
