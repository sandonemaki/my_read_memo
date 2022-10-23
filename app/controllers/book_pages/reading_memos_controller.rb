class BookPages::ReadingMemosController < ApplicationController
  def index
    book = Book.find_by(id: params[:id])
    book_view_model = ViewModel::ReadingMemoViewModel.new(book: book)
    render("index", locals: {book: book_view_model})
  end
end
