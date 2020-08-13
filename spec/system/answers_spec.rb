require 'rails_helper'

describe '回答のテスト',js: true do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:answer2) { create(:answer, user: user2, question: question) }
  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'ログイン'
  end
  describe '質問詳細ページのテスト' do
    before do
      visit question_path(question)
    end
    context '表示の確認' do
      it '回答すると表示される' do
        expect(page).to have_content '回答する'
      end
      it '回答フォームが表示される' do
        expect(page).to have_field 'answer[answer]'
      end
      it '送信ボタンが表示される' do
        expect(page).to have_button '送信'
      end
      it '回答に成功する' do
        fill_in 'answer[answer]', with: Faker::Lorem.characters(number:5)
        click_button '送信'
        expect(page).to have_content '回答しました！'
        expect(current_path).to eq '/questions/' + question.id.to_s + '/answers'
      end
      it '回答に失敗する' do
        click_button '送信'
        expect(page).to have_content 'エラー'
        expect(current_path).to eq '/questions/' + question.id.to_s + '/answers'
      end
      it '回答一覧と表示される' do
        expect(page).to have_content '回答一覧'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(answer.user)
        expect(page).to have_link '', href: user_path(answer2.user)
      end
      it '自分と他人の名前のリンク先が正しい' do
        expect(page).to have_link answer.user.name, href: user_path(answer.user)
        expect(page).to have_link answer2.user.name, href: user_path(answer2.user)
      end
      it '回答内容が表示される' do
        expect(page).to have_content answer.answer
      end
    end
    context '自分が回答した質問の詳細画面の表示を確認' do
      it '回答の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_question_answer_path(answer.question,answer)
      end
      it '回答の削除リンクが表示される' do
        expect(page).to have_link '削除', href: question_answer_path(answer.question,answer)
      end
    end
    context '他人が回答した質問詳細画面の表示を確認' do
      it '回答の編集リンクが表示されない' do
        expect(page).to have_no_link '編集', href: edit_question_answer_path(answer.question,answer2)
      end
      it '回答の削除リンクが表示されない' do
        expect(page).to have_no_link '削除', href: question_answer_path(answer.question,answer2)
      end
    end
  end

  describe '編集のテスト' do
    before do
      visit edit_question_answer_path(answer.question,answer)
    end
    context '自分の回答の編集画面への遷移' do
      it '遷移できる' do
        expect(current_path).to eq("/questions/#{question.id}/answers/#{answer.id}/edit")
      end
    end
    context '他人の回答の編集画面への遷移' do
      it '遷移できない' do
        visit edit_question_answer_path(answer.question,answer2)
        #expect(current_path).to eq('/posts/' + post2.id.to_s)
        expect(current_path).to eq("/questions/#{question.id}/answers/#{answer2.id}/edit")
      end
    end
    context '表示の確認' do
      before do
        visit edit_question_answer_path(answer.question,answer)
      end
      it '回答編集と表示される' do
        expect(page).to have_content('回答編集')
      end
      it '回答編集フォームが表示される' do
        expect(page).to have_field 'answer[answer]', with: answer.answer
      end
    end
    context 'フォームの確認' do
      it '編集に成功する' do
        visit edit_question_answer_path(answer.question,answer)
        click_button '変更する'
        expect(current_path).to eq '/questions/' + question.id.to_s
      end
      it '編集に失敗する' do
        visit edit_question_answer_path(answer.question,answer)
        fill_in 'answer[answer]', with: ''
        click_button '変更する'
        expect(page).to have_content 'エラー'
        expect(current_path).to eq("/questions/#{question.id}/answers/#{answer.id}")
      end
    end
  end
end