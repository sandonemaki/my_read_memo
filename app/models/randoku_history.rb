class RandokuHistory < ApplicationRecord

  def self.set(new_path, book_id)
    randoku_history = RandokuHistory.find_or_initialize_by(id: 1)
    randoku_history.path = new_path
    randoku_history.book_id = book_id
    randoku_history.save
  end
end
