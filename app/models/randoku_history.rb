class RandokuHistory < ApplicationRecord

  def self.set(new_path, book_id)
    if RandokuHistory.exists?(id: 1)
      randoku_history = RandokuHistory.find_by(id: 1)
      randoku_history.path = new_path
      randoku_history.book_id = book_id
    else
      randoku_history = RandokuHistory.new(path: new_path, book_id: book_id)
    end
    randoku_history.save
  end
end
