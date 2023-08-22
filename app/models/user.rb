class User < ApplicationRecord
  validates :auth0_id, uniqueness: true
end
