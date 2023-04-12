require 'rails_helper'

RSpec.describe Book, type: :model do
  describe "バリデーション" do
    subject(:valid?) { book.valid? }

    let(:book) { Book.new(title: title, author_1: author_1, total_page: total_page) }
    let(:title) { "ダイニングタイトル" }
    let(:author_1) { "東野智子" }
    let(:total_page) { 100 }

    context 'すべての属性が有効なとき' do
      it 'バリデーションが通ること' do
        expect(valid?).to eq true
      end
    end

    context 'タイトルがないとき' do
      let(:title) { nil }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:title]).to include("タイトルを入力してください")
      end
    end

    context '著者がないとき' do
      let(:author_1) { nil }
      it 'バリデーションエラーが発生すること' do
        valid?
        expect(book.errors[:author_1]).to include("著者を入力してください")
      end
    end

  end
end
RSpec.describe Book, type: :model do
  it "タイトル、著者、読む予定のページ数があれば有効な状態であること" do
    book = Book.new(
      title: "ダイニングタイトル",
      author_1: "東野智子",
      total_page: 100
    )
    expect(book).to be_valid
  end

  it "タイトルがなければ無効な状態であること" do
    book = Book.new(title: nil)
    book.valid?
    expect(book.errors[:title]).to include("タイトルを入力してください")
  end

  it "著者がなければ無効な状態であること" do
    book = Book.new(author_1: nil)
    book.valid?
    expect(book.errors[:author_1]).to include("著者を入力してください")
  end

  it "読む予定のページ数が存在しなければ無効な状態であること" do
    book = Book.new(total_page: nil)
    book.valid?
    expect(book.errors[:total_page]).to include("読む予定のページ数を入力してください")
  end

  it "タイトルが30文字以下であること" do
    book = Book.new(title: "a" * 31)
    book.valid?
    expect(book.errors[:title]).to include("30文字以内で入力してください")
  end

  it "著者の入力が30字以下であること" do
    book = Book.new(author_1: "a" * 31)
    book.valid?
    expect(book.errors[:author_1]).to include("30文字以内で入力してください")

  end

  it "読む予定のページ数は1-999ページまでであること" do
    book = Book.new(total_page: 1000)
    book.valid?
    expect(book.errors[:total_page]).to include("登録できるページ数は999ページまでです")
  end
end
