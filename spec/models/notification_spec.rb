require 'rails_helper'

RSpec.describe 'Notificationモデルのテスト', type: :model do
  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:post).macro).to eq :belongs_to
      end
    end
    context 'Questionモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:question).macro).to eq :belongs_to
      end
    end
    context 'Commentモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:comment).macro).to eq :belongs_to
      end
    end
    context 'Answerモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:answer).macro).to eq :belongs_to
      end
    end
    context 'Messageモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:message).macro).to eq :belongs_to
      end
    end
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Notification.reflect_on_association(:visiter).macro).to eq :belongs_to
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
  end
end