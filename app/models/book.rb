class Book < ApplicationRecord
  belongs_to :user
  has_many :randoku_imgs, dependent: :destroy
  has_many :randoku_memos, dependent: :destroy
  has_many :seidoku_memos, dependent: :destroy

  validates :title, presence: { message: 'タイトルを入力してください' }
  validates :title, length: { maximum: 30, message: '30文字以内で入力してください' }
  validates :author_1, presence: { message: '著者を入力してください' }
  validates :author_1, length: { maximum: 30, message: '30文字以内で入力してください' }
  validates :total_page,
            presence: {
              message: '読書する本のページ数を入力してください',
            },
            inclusion: {
              in: 20..999,
              message: '登録できるページ数は20〜999ページです',
            }

  # bookオブジェクトを引数にとる
  # トータルページ、さらさら読書画像メモの未読・既読の数によって状態を判定し、
  # その状態がdbと差異があれば更新するかどうかを判定するメソッド
  # totalpage、さらさら読書画像メモの数、未読既読の数に変更があった時に呼び出される
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
    is_updated = self.reading_state_update?(new_reading_state)
    { updated: is_updated }
  end

  # 上記try_update_reading_stateメソッドのcase文の戻り値を引数にとる
  # bookテーブルのreading_stateカラムをupdateするか判定するメソッド
  # dbの値と差異があれば新規の値を保存する
  # 戻り値：true（更新成功）、false（更新失敗）、nil（変化がないため更新なし）
  def reading_state_update?(new_reading_state)
    if self.reading_state != new_reading_state
      self.reading_state = new_reading_state
      self.save
    else
      nil
    end
  end

  # 「じっくり読書」までにあと何枚画像メモを読む/足す
  def countdown_remaining_seidoku
    img_unread_count = self.randoku_imgs.where(reading_state: '0').count # 未読の数
    already_read_count = self.randoku_imgs.where(reading_state: '1').count # 既読の数

    seidoku_line_1 = (self.total_page * (1.0 / 8.0)).ceil
    randoku_imgs_count = img_unread_count + already_read_count
    current_state = self.reading_state

    case current_state
    when State::READING_STATE.key('さらさら読書：乱読')
      remaining_to_seidoku = seidoku_line_1 - randoku_imgs_count
      "「じっくり読書」まで「さらさら画像メモ」をあと #{remaining_to_seidoku == 0 ? sprintf('%.1f', remaining_to_seidoku) : remaining_to_seidoku.to_i} 枚追加"
    when State::READING_STATE.key('じっくり読書：精読')
      '「さらさら読書」完了！ 残りのメモを読んで「じっくり読書」へ'
    when State::READING_STATE.key('さらさら読書：通読')
      seidoku_line_2 = (self.total_page * (1.0 / 4.0)).floor
      remaining_to_unread = img_unread_count - (seidoku_line_2 - 1)
      "「じっくり読書」まで「さらさら画像メモ」をあと #{remaining_to_unread == 0 ? sprintf('%.1f', remaining_to_unread) : remaining_to_unread.to_i} 枚読む"
    end
  end
end
