require 'rails_helper'

RSpec.describe Answer, type: :model do

  it { should validate_presence_of :body }
  it { should validate_presence_of :user }
  it { should belong_to(:question) }

end
