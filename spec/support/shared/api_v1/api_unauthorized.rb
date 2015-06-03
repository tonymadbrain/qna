RSpec.shared_examples_for 'API unauthorized' do
  it 'returns status unauthorized if access_token is not provided' do
    do_request
    expect(response).to be_unauthorized
  end

  it 'returns status unauthorized if access_token is invalid' do
    do_request access_token: SecureRandom.hex
    expect(response).to be_unauthorized
  end
end