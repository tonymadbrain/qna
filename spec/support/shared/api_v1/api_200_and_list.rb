  shared_examples_for "API 200_and_list" do
  it 'returns 200 status code' do
    expect(response).to be_success
  end

  it "returns list of resource" do
    expect(response.body).to have_json_size(3).at_path("#{resource}s")
  end
end