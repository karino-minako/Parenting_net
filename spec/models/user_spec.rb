require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do
  # 名前が空欄で登録できない→名前を空欄で登録したらfalse
  # バリデーションしていない状態で失敗→設定したら成功
  # 登録できるかできないか 登録できたら失敗
  # エラーメッセージがなければ失敗

  describe 'バリデーションのテスト' do
    let(:user) { build(:user) }
    subject { test_user.valid? }
    context 'nameカラム' do
      let(:test_user) { user }
      it '空欄でないこと' do
        test_user.name = ''
        is_expected.to eq false;
      end
      it '20文字以下であること' do
        test_user.name = Faker::Lorem.characters(number:21)
        is_expected.to eq false;
      end
    end

    context 'introductionカラム' do
      let(:test_user) { user }
      it '50文字以下であること' do
        test_user.introduction = Faker::Lorem.characters(number:51)
        is_expected.to eq false
      end
    end
  end
  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
    context 'Questionモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:questions).macro).to eq :has_many
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Answerモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:answers).macro).to eq :has_many
      end
    end
    context 'PostLikeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:post_likes).macro).to eq :has_many
      end
    end
    context 'Empathyモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:empathies).macro).to eq :has_many
      end
    end
    context 'CommentLikeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:comment_likes).macro).to eq :has_many
      end
    end
    context 'AnswerLikeモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:answer_likes).macro).to eq :has_many
      end
    end
    context 'Messageモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:messages).macro).to eq :has_many
      end
    end
    context 'Entryモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:entries).macro).to eq :has_many
      end
    end
    context 'Relationshipモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:follower).macro).to eq :has_many
        expect(User.reflect_on_association(:followed).macro).to eq :has_many
      end
    end
    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:active_notifications).macro).to eq :has_many
        expect(User.reflect_on_association(:passive_notifications).macro).to eq :has_many
      end
    end
  end
end
# アソシエーションのテスト