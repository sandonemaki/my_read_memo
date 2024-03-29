require 'rails_helper'

RSpec.describe SeidokuHistory, type: :model do
  describe '.set' do
    # テスト用のUserオブジェクトを作成
    before { @user = User.create!(auth0_id: 'auth0|1234', nickname: 'TestUser') }

    let(:book) do
      Book.create(
        title: 'ダイニングタイトル',
        author_1: '東野智子',
        total_page: 100,
        reading_state: 1,
        user_id: @user.id,
      )
    end

    let(:new_path) { "books/#{book.id}" }

    context 'じっくり読書の前回の本のレコードが存在しない場合' do
      it 'じっくり読書の前回の本のレコードの数が1件増える' do
        expect { SeidokuHistory.set(new_path, book.id) }.to change { SeidokuHistory.count }.by(1)

        seidoku_history = SeidokuHistory.last
        expect(seidoku_history.path).to eq new_path
        expect(seidoku_history.book_id).to eq book.id
      end
    end

    context 'じっくり読書の前回の本のレコードが存在する場合' do
      before { SeidokuHistory.create(path: 'old_path', book_id: 1) }

      it 'じっくり読書の前回の本のレコードの数が100件以下であること' do
        expect { SeidokuHistory.set(new_path, book.id) }.not_to change { SeidokuHistory.count <= 100 }

        seidoku_history = SeidokuHistory.last
        expect(seidoku_history.path).to eq new_path
        expect(seidoku_history.book_id).to eq book.id
      end
    end
  end
end
