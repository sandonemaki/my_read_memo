class SeidokuHistory < ApplicationRecord

  def self.set(new_path, book_id)
    randoku_history = SeidokuHistory.order(:created_at).first_or_initialize
    randoku_history.path = new_path
    randoku_history.book_id = book_id
    randoku_history.save
  end
end
