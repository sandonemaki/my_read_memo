module ViewModel

  class NewViewModel
    attr_reader :title, :author_1, :publisher, :total_page, :errors

    def initialize(title:, author_1:, publisher:, total_page:, errors:)
      @title = title
      @author_1 = author_1
      @publisher = publisher
      @total_page = total_page
      @errors = errors
    end
  end

  class ShowViewModel
    attr_reader :id, :title, :author_1, :publisher, :total_page, :errors

    def initialize(id:, title:, author_1:, publisher:, total_page:, errors:)
      @id = id
      @title = title
      @author_1 = author_1
      @publisher = publisher
      @total_page = total_page
      @errors = errors
    end
  end
end
