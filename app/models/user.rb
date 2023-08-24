class User < ApplicationRecord
  has_many :books, dependent: :destroy
  validates :auth0_id, uniqueness: true
end
