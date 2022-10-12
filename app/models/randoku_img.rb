class RandokuImg < ApplicationRecord
  belongs_to :book

  def show_for_randoku_img_view_model(randoku_imgs)
    files = randoku_imgs.files(book)
    count = randoku_imgs.reading_state_count(book)
    read_again_count = count[:read_again]
    finish_read_count = count[:finish_read]
    return RandokuImgViewModel::ShowViewModel.new(
      files: files,
      read_again_count: read_again_count,
      finish_read_count: finish_read_count,
    )
  end

  # 用途
  # - 乱読画像のstate数をDBからの呼び出す
  # - loadedをしていたらDBに問い合わせをせずカウントする
  def reading_state_count(book)
    if book.randoku_imgs.loaded?
      reading_state = book.randoku_imgs.group('reading_state').size
    else
      reading_state = book.randoku_imgs.group('reading_state').count
    end
    #read_again = (reading_state[0] ||= 0)
    #finish_read = (reading_state[1] ||= 0)
    return { read_again: reading_state[0] ||= 0,
             finish_read: reading_state[1] ||= 0 }
  end

  # 用途
  # viewで乱読画像を表示する
  # - 更新順
  # - 生成順_現在は使用しない
  #
  def files(book)
    randoku_img_paths = Dir.glob("public/#{book.id}/thumb/*")
      .sort_by { |randoku_img_path| File.mtime(randoku_img_path) }.reverse
    # ファイル名の取得
    return randoku_img_files = randoku_img_paths.map { |f| f.gsub(/public\/#{book.id}\/thumb\//, '') }
  end
end
