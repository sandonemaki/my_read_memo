class RandokuImgViewModel

  class ShowViewModel
    attr_reader :files

    def initialize(files:)
      @files = files
    end
  end
end
