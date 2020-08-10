require 'rails_helper'

describe 'コメントのテスト',js: true do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:post) { create(:post, user: user) }
  let!(:comment) { create(:comment, user: user, post: post) }
  let!(:comment2) { create(:comment, user: user2, post: post) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  describe '投稿詳細ページのテスト' do
    before do
      visit post_path(post)
    end
    context '表示の確認' do
      it 'コメントすると表示される' do
        expect(page).to have_content 'コメントする'
      end
      it 'コメントフォームが表示される' do
        expect(page).to have_field 'comment[comment]'
      end
      it '送信ボタンが表示される' do
        expect(page).to have_button '送信'
      end
      it 'コメントに成功する' do
        fill_in 'comment[comment]', with: Faker::Lorem.characters(number:5)
        click_button '送信'
        wait_for_ajax do
          expect(page).to have_content 'コメントしました！'
          expect(current_path).to eq '/posts/' + post.id.to_s
        end
      end
      it 'コメントに失敗する' do
        click_button '送信'
        expect(page).to have_content 'error'
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'コメント一覧と表示される' do
        expect(page).to have_content 'コメント一覧'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(comment.user)
        expect(page).to have_link '', href: user_path(comment2.user)
      end
      it '自分と他人の名前のリンク先が正しい' do
        expect(page).to have_link comment.user.name, href: user_path(comment.user)
        expect(page).to have_link comment2.user.name, href: user_path(comment2.user)
      end
      it 'コメント内容が表示される' do
        expect(page).to have_content comment.comment
      end
    end
    context '自分がコメントした投稿の詳細画面の表示を確認' do
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_post_comment_path(comment.post,comment)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: post_comment_path(comment.post,comment)
      end
    end
    context '他人の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示されない' do
        expect(page).to have_no_link '編集', href: edit_post_comment_path(comment.post,comment2)
      end
      it '投稿の削除リンクが表示されない' do
        expect(page).to have_no_link '削除', href: post_comment_path(comment.post,comment2)
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_post_comment_path(comment.post,comment)
    end
    context '自分の投稿の編集画面への遷移' do
      it '遷移できる' do
        expect(current_path).to eq("/posts/#{post.id}/comments/#{comment.id}/edit")
      end
    end
    context '他人の投稿の編集画面への遷移' do
      it '遷移できない' do
        visit edit_post_comment_path(comment.post,comment2)
        #expect(current_path).to eq('/posts/' + post2.id.to_s)
        expect(current_path).to eq("/posts/#{post.id}/comments/#{comment2.id}/edit")
      end
    end
    context '表示の確認' do
      before do
        visit edit_post_comment_path(comment.post,comment)
      end
      it 'コメント編集と表示される' do
        expect(page).to have_content('コメント編集')
      end
      it 'コメント編集フォームが表示される' do
        expect(page).to have_field 'comment[comment]', with: comment.comment
      end
    end
    context 'フォームの確認' do
      it '編集に成功する' do
        visit edit_post_comment_path(comment.post,comment)
        click_button '変更する'
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '編集に失敗する' do
        visit edit_post_comment_path(comment.post,comment)
        fill_in 'comment[comment]', with: ''
        click_button '変更する'
        expect(page).to have_content 'error'
        expect(current_path).to eq("/posts/#{post.id}/comments/#{comment.id}")
      end
    end
  end
end