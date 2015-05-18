require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  it { should validate_presence_of :body and :user_id and :commentable_id and :commentable_type }
  it { should belong_to :commentable }
  it { should belong_to :user }

end
