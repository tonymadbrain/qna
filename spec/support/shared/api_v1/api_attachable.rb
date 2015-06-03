shared_examples_for "API attachable" do
  context 'attachments' do
    it 'included in object' do
      expect(response.body).to have_json_size(1).at_path("#{resource}/attachments")
    end

    it 'contains url' do
      expect(response.body).to be_json_eql(attachment.file.url.to_json). at_path("#{resource}/attachments/0/url")
    end
  end
end