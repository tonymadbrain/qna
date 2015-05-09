RSpec.shared_examples_for 'attachable' do
    it { should have_many(:attachments) }
    it { should accept_nested_attributes_for :attachments }
end