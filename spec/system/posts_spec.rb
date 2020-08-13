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
  describe '新規投稿ページのテスト' do
    before do
      visit new_post_path
    end
    context "新規投稿ページが正しく表示される" do
      it '新規投稿ページに遷移できること' do
        expect(current_path).to eq('/posts/new')
      end
    end
    context '表示の確認' do
      it '新規投稿と表示される' do
        expect(page).to have_content '新規投稿'
      end
      it 'タイトルフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it '内容フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it 'Create Postボタンが表示される' do
        expect(page).to have_button '登録する'
      end
      it '投稿に成功する' do
        fill_in 'post[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number:20)
        click_button '登録する'
        latest_post_id = Post.maximum(:id)
        expect(current_path).to eq '/posts/' + latest_post_id.to_s
      end
      it '投稿に失敗する' do
        click_button '登録する'
        expect(page).to have_content 'エラー'
        expect(current_path).to eq('/posts')
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_post_path(post)
    end
    context '自分の投稿の編集画面への遷移' do
      it '遷移できる' do
        expect(current_path).to eq('/posts/' + post.id.to_s + '/edit')
      end
    end
    context '他人の投稿の編集画面への遷移' do
      it '遷移できない' do
        visit edit_post_path(post2)
        expect(current_path).to eq('/posts/' + post2.id.to_s)
      end
    end
    context '表示の確認' do
      before do
        visit edit_post_path(post)
      end
      it '投稿編集と表示される' do
        expect(page).to have_content('投稿編集')
      end
      it 'タイトル編集フォームが表示される' do
        expect(page).to have_field 'post[title]', with: post.title
      end
      it '内容編集フォームが表示される' do
        expect(page).to have_field 'post[body]', with: post.body
      end
    end
    context 'フォームの確認' do
      it '編集に成功する' do
        visit edit_post_path(post)
        click_button '変更する'
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it '編集に失敗する' do
        visit edit_post_path(post)
        fill_in 'post[title]', with: ''
        click_button '変更する'
        expect(page).to have_content 'エラー'
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit posts_path
    end
    context '表示の確認' do
      it '投稿一覧と表示される' do
        expect(page).to have_content '投稿一覧'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(post2.user)
      end
      it '自分と他人の名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
        expect(page).to have_link post2.user.name, href: user_path(post2.user)
      end
      it '自分と他人のタイトルのリンク先が正しい' do
        expect(page).to have_link post.title, href: post_path(post)
        expect(page).to have_link post2.title, href: post_path(post2)
      end
    end
  end

  describe '詳細画面のテスト' do
    context '自分・他人共通の投稿詳細画面の表示を確認' do
      it '投稿詳細と表示される' do
        visit post_path(post)
        expect(page).to have_content '投稿詳細'
      end
      it 'ユーザー画像・名前のリンク先が正しい' do
        visit post_path(post)
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のタイトルが表示される' do
        visit post_path(post)
        expect(page).to have_content post.title
      end
      it '投稿の内容が表示される' do
        visit post_path(post)
        expect(page).to have_content post.body
      end
    end
    context '自分の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示される' do
        visit post_path post
        expect(page).to have_link '編集', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        visit post_path post
        expect(page).to have_link '削除', href: post_path(post)
      end
    end
    context '他人の投稿詳細画面の表示を確認' do
      it '投稿の編集リンクが表示されない' do
        visit post_path(post2)
        expect(page).to have_no_link '編集', href: edit_post_path(post2)
      end
      it '投稿の削除リンクが表示されない' do
        visit post_path(post2)
        expect(page).to have_no_link '削除', href: post_path(post2)
      end
    end
  end
end