module ViewModel
  class Search
    attr_reader :selected_memos, :randoku_memo_type, :seidoku_memo_type

    def initialize(all_randoku_state_books:, all_seidoku_state_books:, content_type:,
                   randoku_memo_type:, seidoku_memo_type:)
      @selected_memos =
        case content_value
        when content_value.include?("randoku")
          all_randoku_state_books.where(content_state: "#{content_type.match(/[(0-2)]/).to_s}")
        when content_value.include?("seidoku")
          all_seidoku_state_books.where(content_state: "#{content_type.match(/[(0-3)]/).to_s}")
        end
      @randoku_memo_type = randoku_memo_type
      @seidoku_memo_type = seidoku_memo_type
    end
  end
end
