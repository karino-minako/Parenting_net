require 'rails_helper'

RSpec.describe 'Questionモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let!(:question) { build(:question, user_id: user.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        question.title = ''
        expect(question.valid?).to eq false;
      end
      it '20文字以下であること' do
        question.title = Faker::Lorem.characters(number:21)
        expect(question.valid?).to eq false;
      end
    end
    context 'bodyカラム' do
      it '空欄でないこと' do
        question.body = ''
        expect(question.valid?).to eq false;
      end
      it '200文字以下であること' do
        question.body = Faker::Lorem.characters(number:201)
        expect(question.valid?).to eq false;
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Question.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Answerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Question.reflect_on_association(:answers).macro).to eq :has_many
      end
    end
    context 'Empathyモデルとの関係' do
      it '1:Nとなっている' do
        expect(Question.reflect_on_association(:empathies).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Question.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end