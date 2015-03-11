class Answer < ActiveRecord::Base
validates :body, presence: true
end
