class BookViewModel

  class NewViewModel
    attr_reader :title, :author_1, :author_2, :publisher, :total_page

    def initialize(title:, author_1:, author_2:, publisher:, total_page:)
      @title = title
      @author_1 = author_1
      @author_2 = author_2
      @publisher = publisher
      @total_page = total_page
    end
  end
end
