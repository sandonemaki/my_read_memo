class RandokuMemo < ApplicationRecord
  validates :content, presence: true, allow_blank: false
  belongs_to :book
end
