require 'rails_helper'
describe '投稿のテスト' do
  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
 let!(:post) { create(:post, user: user) }
  let!(:post2) { create(:post, user: user2) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
  	click_button 'ログイン'
  end
  describe '新規投稿ページ' do
    context "新規投稿ページが正しく表示される" do
      it '新規投稿ページに遷移できること' do
        visit new_post_path
        expect(current_path).to eq('/posts/new')
      end
	  end
	end
end