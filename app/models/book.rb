class Book < ApplicationRecord
  has_many :randoku_imgs, dependent: :destroy
  has_many :randoku_memos, dependent: :destroy
  has_many :seidoku_memos, dependent: :destroy
  validates :title, presence: {message: "タイトルを入力してください"}
  validates :title, length: {maximum: 30, message: "30文字以内で入力してください"}
  validates :author_1, presence: {message: "著者を入力してください"}
  validates :author_1, length: {maximum: 30, message: "30文字以内で入力してください"}

  def try_update_reading_state(book:, judgement_type:)
    new_reading_state = case judgement_type
    when State::ReadingState::Randoku
      0
    when State::ReadingState::Seidoku
      1
    when State::ReadingState::Tudoku
      2
    else
      raise TypeError, "無効の型が判定されました"
    end

    if book.reading_state != new_reading_state
      book.reading_state = new_reading_state
      book.save
    end
  end
end
