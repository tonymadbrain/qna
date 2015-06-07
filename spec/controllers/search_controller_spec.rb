require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    it 'receives #search method without condition' do
      expect(ThinkingSphinx).to receive(:search).with('test_query')
      get :search, query: 'test_query'
    end

    %w(Question Answer Comment User).each do |attr|
      it "receives #search method with #{ attr }s condition" do
        expect(attr.constantize).to receive(:search).with('test_query')
        get :search, query: 'test_query', condition: "#{ attr }s"
      end
    end
  end
end