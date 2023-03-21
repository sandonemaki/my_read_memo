module ViewModel

  class BooksNew
    attr_reader :id, :title, :author, :total_page, :publisher, :errors

    # @param book [Book] 本モデル
    def initialize(book:)
      @id = book.id
      @title = book.title
      @author = book.author_1
      @total_page = book.total_page
      @publisher = book.publisher
      @errors = book.errors
   end
  end
end
