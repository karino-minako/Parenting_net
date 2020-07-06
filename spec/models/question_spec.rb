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
  end
end