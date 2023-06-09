class TestController < ApplicationController
  def index
    book = Book.find_by(id: 3)
    new_path = "books/#{book.id}"
    book_view_model = ViewModel::TestBookRandokuImgs.new(book: book)
    render('index', locals: { book: book_view_model })
  end
end
