require 'rails_helper'

RSpec.describe SubscribeList, type: :model do
  it { should belong_to :subscriber }
  it { should belong_to :subscription }
end
