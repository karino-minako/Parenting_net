require 'rails_helper'

RSpec.describe 'AnswerLikeモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(AnswerLike.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Answerモデルとの関係' do
      it 'N:1となっている' do
        expect(AnswerLike.reflect_on_association(:answer).macro).to eq :belongs_to
      end
    end
  end
end