class User < ApplicationRecord
  has_many :books, dependent: :destroy
  validates :auth0_id, uniqueness: true
  validates :nickname, length: { maximum: 13, message: '13文字以内で入力してください' }
end
