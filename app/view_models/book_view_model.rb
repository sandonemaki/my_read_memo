class BookViewModel

  class NewViewModel
    attr_reader :title, :author_1, :author_2, :publisher, :total_page, :reading_state

    def initialize(title:, author_1:, author_2:, publisher:, total_page:, reading_state:)
      @title = title
      @author_1 = author_1
      @author_2 = author_2
      @publisher = publisher
      @total_page = total_page
      @reading_state = reading_state
    end
  end
end
