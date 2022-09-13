class Book < ApplicationRecord
  validates :title, presence: {message: "タイトルを入力してください"}
  validates :title, length: {maximum: 10, message: "10文字以内で入力してください"}
  validates :author_1, presence: {message: "著者を入力してください"}
  validates :author_1, length: {maximum: 10, message: "10文字以内で入力してください"}
end
