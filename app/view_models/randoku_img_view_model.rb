class RandokuImgViewModel
  # viewsに表示するための乱読画像のカウント
  class IndexViewModel
    attr_reader :counted_read_again, :counted_finish_read, :counted_read_state

    def initialize
      @counted_read_again = counted_read_again
      @counted_finish_read = counted_finish_read
      @counted_read_state = counted_read_state
    end
  end

  class ShowViewModel
    attr_reader :files, :read_again, :finish_read

    def initialize(files:, read_again:, finish_read:)
      @files = files
      @read_again = read_again
      @finish_read = finish_read
    end
  end
end
