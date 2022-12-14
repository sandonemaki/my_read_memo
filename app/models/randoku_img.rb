class RandokuImg < ApplicationRecord
  belongs_to :book

 # def show_for_randoku_img_view_model(randoku_imgs)
 #   files = randoku_imgs.files(book)
 #   counted = randoku_imgs.reading_state_count(book)
 #   counted_read_again = counted[:read_again]
 #   counted_finish_read = counted[:finish_read]
 #   return RandokuImgViewModel::ShowViewModel.new(
 #     files: files,
 #     counted_read_again: counted_read_again,
 #     counted_finish_read: counted_finish_read
 #   )
 # end

  # 用途
  # - 乱読画像のstate数をDBからの呼び出す
  # - loadedをしていたらDBに問い合わせをせずカウントする
#  def reading_state_count(book)
#    if book.randoku_imgs.loaded?
#      reading_state = book.randoku_imgs.group('reading_state').size
#    else
#      reading_state = book.randoku_imgs.group('reading_state').count
#    end
#    #read_again = (reading_state[0] ||= 0)
#    #finish_read = (reading_state[1] ||= 0)
#    return { read_again: reading_state[0] ||= 0,
#             finish_read: reading_state[1] ||= 0 }
#  end
#
  # 用途
  # viewで乱読画像を表示する
  # - 更新順
  # - 生成順_現在は使用しない
  #
#  def files(book)
#    Dir.glob("public/#{book.id}/thumb/*")
#      .sort_by { |randoku_img_path| File.mtime(randoku_img_path) }
#      .map { |f| f.split("/").last }
#      .reverse
#  end
end
