class RandokuImgViewModel

  class ShowViewModel
    attr_reader :files, :read_again, :finish_read

    def initialize(files:, read_again:, finish_read:)
      @files = files
      @read_again = read_again
      @finish_read = finish_read
    end
  end
end
