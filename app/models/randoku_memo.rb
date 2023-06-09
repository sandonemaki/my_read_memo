class RandokuMemo < ApplicationRecord
  validates :content, presence: { message: '内容を入力してください' }, allow_blank: false
  belongs_to :book
end
