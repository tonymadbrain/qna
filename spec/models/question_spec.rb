require 'rails_helper'

RSpec.describe Question, type: :model do

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title and :body and :user }
  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'
end
