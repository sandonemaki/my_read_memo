class Book < ApplicationRecord
  has_many :randoku_imgs, dependent: :destroy
  has_many :randoku_memos, dependent: :destroy
  has_many :seidoku_memos, dependent: :destroy
  validates :title, presence: {message: "タイトルを入力してください"}
  validates :title, length: {maximum: 30, message: "30文字以内で入力してください"}
  validates :author_1, presence: {message: "著者を入力してください"}
  validates :author_1, length: {maximum: 30, message: "30文字以内で入力してください"}
  validates :total_page, presence: {message: "読む予定のページ数を入力してください"},
    inclusion: { in: 1..999, message: "登録できるページ数は999ページまでです" }

  # bookオブジェクトを引数にとる
  # トータルページ、乱読画像の未読・既読の数によって状態を判定し、
  # その状態がdbと差異があれば更新するかどうかを判定するメソッド
  # totalpage、乱読画像の数、未読既読の数に変更があった時に呼び出される
  def try_update_reading_state
    judgement_reading_state_type =
      State::ReadingState.judgement_reading_state_type(
        totalpage:          self.total_page,
        already_read_count: self.randoku_imgs.where(reading_state: "1").count, #既読の数
        unread_count:       self.randoku_imgs.where(reading_state: "0").count #未読の数
      )

    new_reading_state = case judgement_reading_state_type
    when State::ReadingState::Randoku
      0
    when State::ReadingState::Seidoku
      1
    when State::ReadingState::Tudoku
      2
    else
      raise TypeError, "無効の型が判定されました"
    end
    is_updated = self.reading_satate_update?(new_reading_state)
    { updated: is_updated }
  end

  # 上記try_update_reading_stateメソッドのcase文の戻り値を引数にとる
  # bookテーブルのreading_stateカラムをupdateするか判定するメソッド
  # dbの値と差異があれば新規の値を保存する
  # 戻り値：true、false、nil
  def reading_satate_update?(new_reading_state)
    if self.reading_state != new_reading_state
      self.reading_state = new_reading_state
      self.save
    else
      nil
    end
  end

end
