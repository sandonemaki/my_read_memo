class Book < ApplicationRecord
  has_many :randoku_imgs, dependent: :destroy
  validates :title, presence: {message: "タイトルを入力してください"}
  validates :title, length: {maximum: 30, message: "30文字以内で入力してください"}
  validates :author_1, presence: {message: "著者を入力してください"}
  validates :author_1, length: {maximum: 30, message: "30文字以内で入力してください"}

  def show_for_book_view_model(book)
    book_id = book.id
    book_title = book.title
    book_author_1 = book.author_1
    book_author_2 = book.author_2
    book_publisher = book.publisher
    book_total_page = book.total_page
    book_errors = book.errors
    return BookViewModel::ShowViewModel.new(
      id: book_id,
      title: book_title,
      author_1: book_author_1,
      author_2: book_author_2,
      publisher: book_publisher,
      total_page: book_total_page,
      errors: book_errors,
    )
  end

end
