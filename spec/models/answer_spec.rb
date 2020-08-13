require 'rails_helper'

RSpec.describe 'Answerモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let!(:answer) { build(:answer, user_id: user.id, question_id: question.id) }

    context '回答カラム' do
      it '空欄でないこと' do
        answer.answer = ''
        expect(answer.valid?).to eq false;
      end
      it '200文字以下であること' do
        answer.answer = Faker::Lorem.characters(number:201)
        expect(answer.valid?).to eq false;
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Answer.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Questionモデルとの関係' do
      it 'N:1となっている' do
        expect(Answer.reflect_on_association(:question).macro).to eq :belongs_to
      end
    end
    context 'Answer_likesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Answer.reflect_on_association(:answer_likes).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Answer.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end