require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:post) { create(:post, user_id: user.id) }
    let!(:comment) { build(:comment, user_id: user.id, post_id: post.id) }

    context 'コメントカラム' do
      it '空欄でないこと' do
        comment.comment = ''
        expect(comment.valid?).to eq false;
      end
      it '200文字以下であること' do
        comment.comment = Faker::Lorem.characters(number:201)
        expect(comment.valid?).to eq false;
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Comment_likesモデルとの関係' do
      it '1:Nとなっている' do
        expect(Comment.reflect_on_association(:comment_likes).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Comment.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end