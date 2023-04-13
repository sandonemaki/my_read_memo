require 'rails_helper'

RSpec.describe SeidokuHistory, type: :model do
  describe ".set" do
    let(:book) { Book.create(
      title: "ダイニングタイトル",
      author_1: "東野智子",
      total_page: 100,
      reading_state: 1,
    )}

    let(:new_path) { "books/#{book.id}" }

    context "精読ヒストリーのレコードが存在しない場合" do
      it "精読ヒストリーのレコードの数が1件増える" do
        expect { SeidokuHistory.set(new_path, book.id) }.to change { SeidokuHistory.count }.by(1)

        seidoku_history = SeidokuHistory.last
        expect(seidoku_history.path).to eq new_path
        expect(seidoku_history.book_id).to eq book.id
      end
    end
    
    context "精読ヒストリーのレコードが存在する場合" do
      before do
        seidoku_history = SeidokuHistory.create(path: 'old_path', book_id: 1)
      end

      it "精読ヒストリーのレコードの数が変わらないこと" do
        expect { SeidokuHistory.set(new_path, book.id) }.not_to change { SeidokuHistory.count }

        seidoku_history = SeidokuHistory.last
        expect(seidoku_history.path).to eq new_path
        expect(seidoku_history.book_id).to eq book.id
      end
    end

  end
end