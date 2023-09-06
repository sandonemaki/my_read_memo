require 'rails_helper'

RSpec.describe RandokuHistory, type: :model do
  describe '.set' do
    # テスト用のUserオブジェクトを作成
    before { @user = User.create!(auth0_id: 'auth0|1234', nickname: 'TestUser') }
    let(:book) do
      Book.create(
        title: 'ダイニングタイトル',
        author_1: '東野智子',
        total_page: 100,
        reading_state: 0,
        user_id: @user.id,
      )
    end

    let(:new_path) { "books/#{book.id}" }

    context 'さらさら読書の前回の本のレコードが存在しない場合' do
      it 'さらさら読書の前回の本のレコードの数が1件増える' do
        expect { RandokuHistory.set(new_path, book.id) }.to change { RandokuHistory.count }.by(1)

        randoku_history = RandokuHistory.last
        expect(randoku_history.path).to eq new_path
        expect(randoku_history.book_id).to eq book.id
      end
    end

    context 'さらさら読書の前回の本のレコードが存在する場合' do
      before { RandokuHistory.create(path: 'old_path', book_id: 1) }

      it 'さらさら読書の前回の本のレコードの数が100件以下であること' do
        expect { RandokuHistory.set(new_path, book.id) }.not_to change { RandokuHistory.count <= 100 }

        randoku_history = RandokuHistory.last
        expect(randoku_history.path).to eq new_path
        expect(randoku_history.book_id).to eq book.id
      end
    end
  end
end
