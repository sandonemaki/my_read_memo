class BooksController < ApplicationController
  include Secured
  require_relative '../modules/state'

  def update_total_page
    book = Book.find_by(id: params[:id])
    book.total_page = book_params[:input_total_page]
    if !book.save
      render json: { status: 500, message: '情報が更新されませんでした。もう一度お試しください' }
      return
    end

    # total_pageの保存が成功した後に実行
    total_page_update_result = book.total_page
    book_reading_state_result = book.try_update_reading_state

    #randoku_imgs_group_count = book.randoku_imgs.group('reading_state').size
    #randoku_imgs_unread_count = randoku_imgs_group_count[0] ||= 0 # 未読の数
    seidoku_line_1 = (book.total_page * (1.0 / 8.0)).ceil # 切り上げ
    seidoku_line_2 = (book.total_page * (1.0 / 4.0)).floor # 切り捨て

    # 精読まで未読をあと何枚
    remaining = book.countdown_remaining_seidoku

    # 本の状態の更新があった場合
    if book_reading_state_result[:updated] == true
      # 本の状態
      book_state_updated_info = State::READING_STATE[book.reading_state]
      json_response = {
        status: :ok,
        book_state_updated_info: book_state_updated_info,
        total_page_update_result: total_page_update_result,
        seidoku_line_1: seidoku_line_1,
        seidoku_line_2: seidoku_line_2,
        remaining: remaining,
      }

      # 更新された本の状態が"精読"であれば精読メモのタブの鍵を外す
      # 一度falseになると変更されない
      if book_state_updated_info == '精読'
        book.seidoku_memo_key = false
        unless book.save
          render json: {
                   status: 500,
                   book_state_updated_info: book_state_updated_info,
                   total_page_update_result: total_page_update_result,
                   seidoku_line_1: seidoku_line_1,
                   seidoku_line_2: seidoku_line_2,
                   remaining: remaining,
                   message: '最後まで処理できませんでした。もう一度お試しください',
                 }
          return
        end

        # json_responseに追加
        json_response[:book_seidoku_memo_key] = (book.seidoku_memo_key == false) ? 'key_false' : 'key_true'
      end
      render json: json_response
    elsif book_reading_state_result[:updated] == false
      render json: {
               status: 502,
               total_page_update_result: total_page_update_result,
               seidoku_line_1: seidoku_line_1,
               seidoku_line_2: seidoku_line_2,
               remaining: remaining,
               message: '本のステータスの更新ができませんでした。もう一度お試しください',
             }
    else
      render json: {
               status: :ok,
               total_page_update_result: total_page_update_result,
               seidoku_line_1: seidoku_line_1,
               seidoku_line_2: seidoku_line_2,
               remaining: remaining,
             }
    end
  end

  # ランキング：randoku_indexの乱読画像の多い順
  def index_tabs
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user.nickname = user_info['nickname'].slice(0, 13) if user_info['nickname']
    user.save

    user_books = user.books
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == 精読
    all_books_count = user_books.all.count

    randoku_index_common_view_models =
      ViewModel::BooksRandokuIndexCommon.new(
        books_user: user,
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )

    seidoku_index_common_view_models =
      ViewModel::BooksSeidokuIndexCommon.new(
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )

    randoku_index_rank_view_models =
      ViewModel::BooksRandokuIndexRankMostImgs.new(all_randoku_state_books: all_randoku_state_books)

    seidoku_index_rank_view_models =
      ViewModel::BooksSeidokuIndexRankMostSeidokuMemos.new(all_seidoku_state_books: all_seidoku_state_books)

    render(
      'index_tabs',
      locals: {
        randoku_books: randoku_index_common_view_models,
        randoku_rank: randoku_index_rank_view_models,
        seidoku_books: seidoku_index_common_view_models,
        seidoku_rank: seidoku_index_rank_view_models,
      },
    )
  end

  # ランキング：randoku_indexの乱読画像の多い順
  # fetchでランキングを取得する時に利用する
  # def randoku_index
  #   all_randoku_state_books = Book.where.not(reading_state: '1') # 0 == 乱読, 2 == 通読
  #   all_seidoku_state_books = Book.where(reading_state: '1') # 1 == 精読
  #   all_books_count = Book.all.count

  #   randoku_index_common_view_models =
  #     ViewModel::BooksRandokuIndexCommon.new(
  #       all_randoku_state_books: all_randoku_state_books,
  #       all_seidoku_state_books: all_seidoku_state_books,
  #       all_books_count: all_books_count,
  #     )
  #   randoku_index_rank_view_models =
  #     ViewModel::BooksRandokuIndexRankMostImgs.new(all_randoku_state_books: all_randoku_state_books)
  #   render json: {
  #            status: :ok,
  #            randoku_books: randoku_index_common_view_models,
  #            randoku_rank: randoku_index_rank_view_models,
  #          }
  # end

  # ランキング：randoku_indexの乱読本の投稿順
  def randoku_rank_created_books
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])

    user_books = user.books
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == 精読
    all_books_count = user_books.all.count

    randoku_index_common_view_models =
      ViewModel::BooksRandokuIndexCommon.new(
        books_user: user,
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    seidoku_index_common_view_models =
      ViewModel::BooksSeidokuIndexCommon.new(
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    randoku_index_rank_view_models =
      ViewModel::BooksRandokuIndexRankCreatedBooks.new(all_randoku_state_books: all_randoku_state_books)
    seidoku_index_rank_view_models =
      ViewModel::BooksSeidokuIndexRankMostSeidokuMemos.new(all_seidoku_state_books: all_seidoku_state_books)
    render(
      'index_tabs',
      locals: {
        randoku_books: randoku_index_common_view_models,
        randoku_rank: randoku_index_rank_view_models,
        seidoku_books: seidoku_index_common_view_models,
        seidoku_rank: seidoku_index_rank_view_models,
      },
    )
  end

  # ランキング：randoku_indexの乱読画像の投稿順
  def randoku_rank_created_randoku_imgs
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])

    user_books = user.books
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == 精読
    all_books_count = user_books.all.count

    randoku_index_common_view_models =
      ViewModel::BooksRandokuIndexCommon.new(
        books_user: user,
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    seidoku_index_common_view_models =
      ViewModel::BooksSeidokuIndexCommon.new(
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )

    randoku_index_rank_view_models =
      ViewModel::BooksRandokuIndexRankCreatedImgs.new(all_randoku_state_books: all_randoku_state_books)
    seidoku_index_rank_view_models =
      ViewModel::BooksSeidokuIndexRankMostSeidokuMemos.new(all_seidoku_state_books: all_seidoku_state_books)
    render(
      'index_tabs',
      locals: {
        randoku_books: randoku_index_common_view_models,
        randoku_rank: randoku_index_rank_view_models,
        seidoku_books: seidoku_index_common_view_models,
        seidoku_rank: seidoku_index_rank_view_models,
      },
    )
  end

  # 精読メモの多い順
  def seidoku_index
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_books = user.books

    # TODO: 1の部分をString"乱読"にして数字に変換するメソッドを使う
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == 精読
    all_books_count = user_books.all.count

    randoku_index_common_view_models =
      ViewModel::BooksRandokuIndexCommon.new(
        books_user: user,
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    seidoku_index_common_view_models =
      ViewModel::BooksSeidokuIndexCommon.new(
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    randoku_index_rank_view_models =
      ViewModel::BooksRandokuIndexRankMostImgs.new(all_randoku_state_books: all_randoku_state_books)
    seidoku_index_rank_view_models =
      ViewModel::BooksSeidokuIndexRankMostSeidokuMemos.new(all_seidoku_state_books: all_seidoku_state_books)
    render(
      'index_seidoku_tabs',
      locals: {
        randoku_books: randoku_index_common_view_models,
        randoku_rank: randoku_index_rank_view_models,
        seidoku_books: seidoku_index_common_view_models,
        seidoku_rank: seidoku_index_rank_view_models,
      },
    )
  end

  # 精読本の投稿順
  def seidoku_rank_created_books
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_books = user.books

    # TODO: 1の部分をString"乱読"にして数字に変換するメソッドを使う
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == 精読
    all_books_count = user_books.all.count

    randoku_index_common_view_models =
      ViewModel::BooksRandokuIndexCommon.new(
        books_user: user,
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )

    seidoku_index_common_view_models =
      ViewModel::BooksSeidokuIndexCommon.new(
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    randoku_index_rank_view_models =
      ViewModel::BooksRandokuIndexRankMostImgs.new(all_randoku_state_books: all_randoku_state_books)
    seidoku_index_rank_view_models =
      ViewModel::BooksSeidokuIndexRankCreatedBooks.new(all_seidoku_state_books: all_seidoku_state_books)
    render(
      'index_seidoku_tabs',
      locals: {
        randoku_books: randoku_index_common_view_models,
        randoku_rank: randoku_index_rank_view_models,
        seidoku_books: seidoku_index_common_view_models,
        seidoku_rank: seidoku_index_rank_view_models,
      },
    )
  end

  # 乱読メモの多い順
  def seidoku_rank_most_randoku_imgs
    user_info = session[:userinfo]
    return redirect_to root_path, alert: 'ユーザーが存在しないか、セッションが無効です。' unless user_info

    user = User.find_or_initialize_by(auth0_id: user_info['sub'])
    user_books = user.books

    # TODO: 1の部分をString"乱読"にして数字に変換するメソッドを使う
    all_randoku_state_books = user_books.where.not(reading_state: 1) # 0 == 乱読, 2 == 通読
    all_seidoku_state_books = user_books.where(reading_state: 1) # 1 == 精読
    all_books_count = user_books.all.count

    randoku_index_common_view_models =
      ViewModel::BooksRandokuIndexCommon.new(
        books_user: user,
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    seidoku_index_common_view_models =
      ViewModel::BooksSeidokuIndexCommon.new(
        all_randoku_state_books: all_randoku_state_books,
        all_seidoku_state_books: all_seidoku_state_books,
        all_books_count: all_books_count,
      )
    randoku_index_rank_view_models =
      ViewModel::BooksRandokuIndexRankMostImgs.new(all_randoku_state_books: all_randoku_state_books)
    seidoku_index_rank_view_models =
      ViewModel::BooksSeidokuIndexRankMostRandokuImgs.new(all_seidoku_state_books: all_seidoku_state_books)
    render(
      'index_seidoku_tabs',
      locals: {
        randoku_books: randoku_index_common_view_models,
        randoku_rank: randoku_index_rank_view_models,
        seidoku_books: seidoku_index_common_view_models,
        seidoku_rank: seidoku_index_rank_view_models,
      },
    )
  end

  def new
    book = Book.new
    book_view_model = ViewModel::BooksNew.new(book: book)
    render('new', locals: { book: book_view_model })
  end

  def create
    book = Book.new(book_params)
    if book.save
      redirect_to("/books/#{book.id}")
    else
      book_view_model = ViewModel::BooksNew.new(book: book)
      render('new', locals: { book: book_view_model })
    end
  end

  def edit
    book = Book.find_by(id: params[:id])
    unless book
      flash[:error] = 'ページが見つかりませんでした'
      redirect_to '/books/randoku_index'
      return
    end
    book_view_model = ViewModel::BooksEdit.new(book: book)
    render('edit', locals: { book: book_view_model })
  end

  def update
    book = Book.find_by(id: params[:id])
    if book.update(book_params)
      redirect_to("/books/#{book.id}")
    else
      book_view_model = ViewModel::BooksEdit.new(book: book)
      render('edit', locals: { book: book_view_model })
    end
  end

  def cover_update
    book = Book.find_by(id: params[:id])
    book_view_model = ViewModel::BooksEdit.new(book: book)
    unless book_cover_params[:book_cover].present?
      render('edit', locals: { book: book_view_model })
      return
    end

    uploaded_file = book_cover_params[:book_cover]
    content_type = Marcel::MimeType.for(uploaded_file)

    unless content_type.in? %w[image/jpeg image/jpg image/png image/gif image/heic]
      flash[:error] = 'jpeg, jpg, png, gif形式のファイルを選択してください'
      render('edit', locals: { book: book_view_model })
      return
    end

    dir_path = "public/#{book.id}/book_cover/"

    # ディレクトリが存在しない場合、新たに作成する
    FileUtils.mkdir_p(dir_path) unless File.directory?(dir_path)

    # ディレクトリ内の全ファイルを取得
    Dir.foreach(dir_path) do |filename|
      file_path = File.join(dir_path, filename)

      # ファイルを削除
      File.delete(file_path) if File.file?(file_path)
    end

    new_file_path = "#{dir_path}/cover.#{extension_from_content_type(content_type)}"
    File.binwrite(new_file_path, uploaded_file.read)

    # ImageMagickを使用してリサイズ
    system('convert', new_file_path, '-resize', '185x185^', new_file_path) # 品質指定する場合, '-quality', '90%',

    # Exif情報を削除
    system('mogrify', '-strip', new_file_path)

    # heicをjpgに変換
    if content_type == 'image/heic'
      jpg_path = new_file_path.gsub(/\.heic\z/, '.jpg')

      system('magick', 'mogrify', '-format', 'jpg', new_file_path)

      # 既存のHEICファイルを削除
      File.delete(new_file_path) if File.exist?(new_file_path)

      # ファイルパスをJPGに更新
      new_file_path = jpg_path
    end

    book.cover_path = new_file_path.gsub(/^public/, '')
    if book.save
      redirect_to("/books/#{book.id}/edit")
    else
      flash[:error] = '表紙が保存できませんでした'
      render('edit', locals: { book: book_view_model })
    end
  end

  def extension_from_content_type(content_type)
    case content_type
    when 'image/jpeg'
      'jpg'
    else
      content_type.split('/').last
    end
  end

  # 用途
  # 乱読画像の状態を表示
  # - 状態：また読みたい、読了

  #def show
  #  book = Book.find_by(id: params[:id])
  #  new_path = "books/#{book.id}"

  #  # 学習履歴を保存
  #  # TODO: 数字ではなくモデリング名を使用する
  #  if %w[0 2].include?(book.reading_state.to_s)
  #    RandokuHistory.set(new_path, book.id)
  #  else
  #    SeidokuHistory.set(new_path, book.id)
  #  end

  #  book_view_model = ViewModel::BooksShow.new(book: book)
  #  render('show', locals: { book: book_view_model })
  #end

  def show_tabs
    book = Book.find_by(id: params[:id])
    unless book
      flash[:error] = 'ページが見つかりませんでした'
      redirect_to '/books/randoku_index'
      return
    end
    new_path = "books/#{book.id}"

    # 学習履歴を保存
    if %w[0 2].include?(book.reading_state.to_s)
      RandokuHistory.set(new_path, book.id)
    else
      SeidokuHistory.set(new_path, book.id)
    end

    book_imgs_view_model = ViewModel::BooksShow.new(book: book)
    randoku_memos_view_model = ViewModel::BooksRandokuMemosIndex.new(book: book)
    seidoku_memos_view_model = ViewModel::BooksSeidokuMemosIndex.new(book: book)

    render(
      'show_tabs',
      locals: {
        book: book_imgs_view_model,
        book_randoku_memos: randoku_memos_view_model,
        book_seidoku_memos: seidoku_memos_view_model,
      },
    )
  end

  def book_params
    params.permit(:input_total_page, :title, :author_1, :publisher, :total_page)
  end
  def book_cover_params
    params.permit(:book_cover)
  end
end
