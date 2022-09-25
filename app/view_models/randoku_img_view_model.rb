class RandokuImgViewModel

  class ShowViewModel
    attr_reader :randoku_img_names

    def initialize(randoku_img_names: [])
      @randoku_img_names = randoku_img_names
    end
  end
end
