class BookViewModel

  class IndexViewModel
    attr_reader :id, :titile, :author_1, :author_2, :total_page, :reading_state

    def initialize(id:, author_1:, author_2:, total_page:, reading_state:)
      @id = id
      @author_1 = author_1
      @author_2 = author_2
      @total_page = total_page
      @reading_state = reading_state
    end
  end

  class NewViewModel
    attr_reader :title, :author_1, :author_2, :publisher, :total_page, :errors

    def initialize(title:, author_1:, author_2:, publisher:, total_page:, errors:)
      @title = title
      @author_1 = author_1
      @author_2 = author_2
      @publisher = publisher
      @total_page = total_page
      @errors = errors
    end
  end

  class ShowViewModel
    attr_reader :id, :title, :author_1, :author_2, :publisher, :total_page, :errors

    def initialize(id:, title:, author_1:, author_2:, publisher:, total_page:, errors:)
      @id = id
      @title = title
      @author_1 = author_1
      @author_2 = author_2
      @publisher = publisher
      @total_page = total_page
      @errors = errors
    end
  end
end
