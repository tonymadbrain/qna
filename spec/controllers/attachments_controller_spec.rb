require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do

  describe 'DELETE #destroy' do

    let(:question_user) { create(:user) }
    let(:answer_user) { create(:user) }
    let(:another_user) { create(:user) }
    let!(:question_file) { create(:attachment, attachable: question) }
    let(:answer_file) { create(:attachment, attachable: answer) }
    let(:question) { create(:question, user: question_user) }
    let(:answer) { create(:answer, question: question, user: answer_user) }

    context 'valid question user' do
      
      before do
        sign_in(question_user)
        question_file
      end

      it 'deletes the attachment for question' do
        expect { delete :destroy, id: question_file, format: :js}.to change(Attachment, :count).by(-1)
      end
    end

    context 'invalid user for question' do

      before { sign_in(another_user) }

      it 'not author tries to delete attachment for question' do
        expect { delete :destroy, id: question_file, format: :js}.to_not change(Attachment, :count)
      end
    end

    context 'valid answer user' do

      before do
        sign_in(answer_user) 
        answer_file
      end

      it 'author of the answer deletes the attached file' do
        expect { delete :destroy, id: answer_file, format: :js}.to change(Attachment, :count).by(-1)
      end
    end

    context 'invalid user for answer' do
      
      before do
        sign_in(another_user) 
        answer_file
      end

      it 'restricts to nonauthor to delete file attached to answer' do
        expect{ delete :destroy, id: answer_file, format: :js}.to_not change(Attachment, :count)
      end
    end
  end
end 