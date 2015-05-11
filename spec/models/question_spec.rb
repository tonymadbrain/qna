require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should validate_presence_of :title and :body and :user }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'
end
