require 'rails_helper'

describe '質問のテスト' do
  let(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:question2) { create(:question, user: user2) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  describe '新規質問ページのテスト' do
    before do
      visit new_question_path
    end
    context "新規質問ページが正しく表示される" do
      it '新規質問ページに遷移できること' do
        expect(current_path).to eq('/questions/new')
      end
    end
    context '表示の確認' do
      it '新規質問と表示される' do
        expect(page).to have_content '新規質問'
      end
      it 'タイトルフォームが表示される' do
        expect(page).to have_field 'question[title]'
      end
      it '内容フォームが表示される' do
        expect(page).to have_field 'question[body]'
      end
      it 'Create Postボタンが表示される' do
        expect(page).to have_button '登録する'
      end
      it '質問に成功する' do
        fill_in 'question[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'question[body]', with: Faker::Lorem.characters(number:20)
        click_button '登録する'
        latest_question_id = Question.maximum(:id)
        expect(current_path).to eq '/questions/' + latest_question_id.to_s
      end
      it '質問に失敗する' do
        click_button '登録する'
        expect(page).to have_content 'エラー'
        expect(current_path).to eq('/questions')
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_question_path(question)
    end
    context '自分の質問の編集画面への遷移' do
      it '遷移できる' do
        expect(current_path).to eq('/questions/' + question.id.to_s + '/edit')
      end
    end
    context '他人の質問の編集画面への遷移' do
      it '遷移できない' do
        visit edit_question_path(question2)
        expect(current_path).to eq('/questions/' + question2.id.to_s)
      end
    end
    context '表示の確認' do
      before do
        visit edit_question_path(question)
      end
      it '質問編集と表示される' do
        expect(page).to have_content('質問編集')
      end
      it 'タイトル編集フォームが表示される' do
        expect(page).to have_field 'question[title]', with: question.title
      end
      it '内容編集フォームが表示される' do
        expect(page).to have_field 'question[body]', with: question.body
      end
    end
    context 'フォームの確認' do
      it '編集に成功する' do
        visit edit_question_path(question)
        click_button '変更する'
        expect(current_path).to eq '/questions/' + question.id.to_s
      end
      it '編集に失敗する' do
        visit edit_question_path(question)
        fill_in 'question[title]', with: ''
        click_button '変更する'
        expect(page).to have_content 'エラー'
        expect(current_path).to eq '/questions/' + question.id.to_s
      end
    end
  end

  describe '一覧画面のテスト' do
    before do
      visit questions_path
    end
    context '表示の確認' do
      it '質問一覧と表示される' do
        expect(page).to have_content '質問一覧'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(question.user)
        expect(page).to have_link '', href: user_path(question2.user)
      end
      it '自分と他人の名前のリンク先が正しい' do
        expect(page).to have_link question.user.name, href: user_path(question.user)
        expect(page).to have_link question2.user.name, href: user_path(question2.user)
      end
      it '自分と他人のタイトルのリンク先が正しい' do
        expect(page).to have_link question.title, href: question_path(question)
        expect(page).to have_link question2.title, href: question_path(question2)
      end
    end
  end

  describe '詳細画面のテスト' do
    context '自分・他人共通の質問詳細画面の表示を確認' do
      it '質問詳細と表示される' do
        visit question_path(question)
        expect(page).to have_content '質問詳細'
      end
      it 'ユーザー画像・名前のリンク先が正しい' do
        visit question_path(question)
        expect(page).to have_link question.user.name, href: user_path(question.user)
      end
      it '質問のタイトルが表示される' do
        visit question_path(question)
        expect(page).to have_content question.title
      end
      it '質問の内容が表示される' do
        visit question_path(question)
        expect(page).to have_content question.body
      end
    end
    context '自分の質問詳細画面の表示を確認' do
      it '質問の編集リンクが表示される' do
        visit question_path question
        expect(page).to have_link '編集', href: edit_question_path(question)
      end
      it '質問の削除リンクが表示される' do
        visit question_path question
        expect(page).to have_link '削除', href: question_path(question)
      end
    end
    context '他人の質問詳細画面の表示を確認' do
      it '質問の編集リンクが表示されない' do
        visit question_path(question2)
        expect(page).to have_no_link '編集', href: edit_question_path(question2)
      end
      it '質問の削除リンクが表示されない' do
        visit question_path(question2)
        expect(page).to have_no_link '削除', href: question_path(question2)
      end
    end
  end
end