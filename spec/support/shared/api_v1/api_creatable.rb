shared_examples_for "API creatable" do
  context 'with valid attributes' do
    it 'returns 201 status code' do
      do_request object_attr[0]
      expect(response.status).to eq 201
    end

    it 'saves the new object to database' do
      expect { do_request object_attr[0] }
        .to change(list_for_check, :count).by(1)
    end

    it 'assign new object to current user' do
      do_request object_attr[0]
      expect(assigns(resource).user).to eq(owner_user)
    end
  end

  context 'with invalid attributes' do
    it 'returns 422 status code' do
      do_request object_attr[1]
      expect(response.status).to eq 422
    end

    it 'not saves the new object to database' do
      expect { do_request object_attr[1] }.to_not change(list_for_check, :count)
    end
  end

  def do_request(options = {})
    super({ access_token: access_token.token }.merge(options))
  end
end