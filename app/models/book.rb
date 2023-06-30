class Book < ApplicationRecord
  has_many :randoku_imgs, dependent: :destroy
  has_many :randoku_memos, dependent: :destroy
  has_many :seidoku_memos, dependent: :destroy
  validates :title, presence: { message: 'タイトルを入力してください' }
  validates :title, length: { maximum: 30, message: '30文字以内で入力してください' }
  validates :author_1, presence: { message: '著者を入力してください' }
  validates :author_1, length: { maximum: 30, message: '30文字以内で入力してください' }
  validates :total_page,
            presence: {
              message: '読む予定のページ数を入力してください',
            },
            inclusion: {
              in: 20..999,
              message: '登録できるページ数は20〜999ページです',
            }

  # bookオブジェクトを引数にとる
  # トータルページ、乱読画像の未読・既読の数によって状態を判定し、
  # その状態がdbと差異があれば更新するかどうかを判定するメソッド
  # totalpage、乱読画像の数、未読既読の数に変更があった時に呼び出される
  def try_update_reading_state
    judgement_reading_state_type =
      ReadingStateUtils::StateTypeJudge.determine_state(
        totalpage: self.total_page,
        already_read_count: self.randoku_imgs.where(reading_state: '1').count, #既読の数
        unread_count: self.randoku_imgs.where(reading_state: '0').count, #未読の数
      )

    new_reading_state =
      case judgement_reading_state_type
      when ReadingStateUtils::StateTypeJudge::Randoku
        0
      when ReadingStateUtils::StateTypeJudge::Seidoku
        1
      when ReadingStateUtils::StateTypeJudge::Tudoku
        2
      else
        raise TypeError, '無効の型が判定されました'
      end
    is_updated = self.reading_satate_update?(new_reading_state)
    { updated: is_updated }
  end

  # 上記try_update_reading_stateメソッドのcase文の戻り値を引数にとる
  # bookテーブルのreading_stateカラムをupdateするか判定するメソッド
  # dbの値と差異があれば新規の値を保存する
  # 戻り値：true（更新成功）、false（更新失敗）、nil（変化がないため更新なし）
  def reading_satate_update?(new_reading_state)
    if self.reading_state != new_reading_state
      self.reading_state = new_reading_state
      self.save
    else
      nil
    end
  end

  # 精読まで未読をあと何枚
  def countdown_remaining_seidoku(randoku_imgs_unread_count:, seidoku_line_1:, seidoku_line_2:)
    # 精読中
    randoku_imgs_count = self.randoku_imgs.size
    if seidoku_line_1 <= randoku_imgs_count && randoku_imgs_unread_count < seidoku_line_2
      '精読突破!'
      # 乱読中
    elsif randoku_imgs_count < seidoku_line_1
      "精読まで乱読メモがあと#{seidoku_line_1 - randoku_imgs_count}枚"
      # 通読中
    elsif randoku_imgs_unread_count >= @seidoku_line_2
      "精読まで未読があと#{(seidoku_line_2 - 1) - randoku_imgs_unread_count}枚"
    end
  end
end
