module ViewModel

  class BooksEdit
    attr_reader :id, :title, :author, :total_page, :publisher, :cover_path, :errors

    # @param book [Book] 本モデル
    def initialize(book:)
      @id = book.id
      @title = book.title
      @author = book.author_1
      @total_page = book.total_page
      @publisher = book.publisher
      @cover_path = book.cover_path
      @errors = book.errors
    end
  end
end
