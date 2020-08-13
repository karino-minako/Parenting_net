require 'rails_helper'

RSpec.describe 'PostLikeモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(PostLike.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Questionモデルとの関係' do
      it 'N:1となっている' do
        expect(PostLike.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
  end
end