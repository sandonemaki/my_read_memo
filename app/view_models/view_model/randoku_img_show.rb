# Note
# 乱読画像をクリックしたらモーダルで表示させようとしていたデータ
# 遷移させずにモーダル上で画像を表示させることにしたのでbook_page_controllerのshowアクションから飛ぶBookVIewModelに移動させる
module ViewModel
  class RandokuImgShow
    attr_reader :title, :randoku_imgs_all_count,
      :randoku_imgs_of_current, :randoku_imgs_all

    def initialize(book:, randoku_img:)
      @title = book.title
      @randoku_imgs_all_count = book.randoku_imgs.all.size
      @randoku_img_of_current =
        { id: randoku_img.id,
          updated_at: I18n.l(randoku_img.updated_at, format: :short),
          name: randoku_img.name,
          path: randoku_img.path,
          reading_state: randoku_img.reading_state,
          bookmark_flag: randoku_img.bookmark_flag }

      @randoku_imgs_all =
        book.randoku_imgs.all.order(updated_at: :desc).to_a.map { |img|
          { id: img.id,
            updated_at: I18n.l(img.updated_at, format: :short),
            name: img.name,
            path: img.path,
            reading_state: img.reading_state,
            bookmark_flag: img.bookmark_flag }
        }
    end
  end
end
