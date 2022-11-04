class SeidokuHistory < ApplicationRecord

  def self.set(new_path, book_id)
    if SeidokuHistory.exists?(id: 1)
      seidoku= SeidokuHistory.find_by(id: 1)
      seidoku_history.path = new_path
      seidoku_history.book_id = book_id
    else
      seidoku_history = RandokuHistory.new(path: new_path, book_id: book_id)
    end
    seidoku_history.save
  end
end
