class User < ApplicationRecord
  has_many :books
  validates :auth0_id, uniqueness: true
end
