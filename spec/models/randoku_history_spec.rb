require 'rails_helper'

RSpec.describe RandokuHistory, type: :model do
  describe ".set" do
    let(:book) { Book.create(
      title: "ダイニングタイトル",
      author_1: "東野智子",
      total_page: 100,
      reading_state: 0,
    )}

    let(:new_path) { "books/#{book.id}" }

    context "乱読ヒストリーのレコードが存在しない場合" do
      it "乱読ヒストリーのレコードの数が1件増える" do
        expect { RandokuHistory.set(new_path, book.id) }.to change { RandokuHistory.count }.by(1)

        randoku_history = RandokuHistory.last
        expect(randoku_history.path).to eq new_path
        expect(randoku_history.book_id).to eq book.id
      end
    end
    
    context "乱読ヒストリーのレコードが存在する場合" do
      before do
        randoku_history = RandokuHistory.create(path: 'old_path', book_id: 1)
      end

      it "乱読ヒストリーのレコードの数が変わらないこと" do
        expect { RandokuHistory.set(new_path, book.id) }.not_to change { RandokuHistory.count }

        randoku_history = RandokuHistory.last
        expect(randoku_history.path).to eq new_path
        expect(randoku_history.book_id).to eq book.id
      end
    end

  end
end
