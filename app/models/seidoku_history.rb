class SeidokuHistory < ApplicationRecord

  def self.set(new_path, book_id)
    seidoku_history = SeidokuHistory.order(:created_at).first_or_initialize
    seidoku_history.path = new_path
    seidoku_history.book_id = book_id
    seidoku_history.save
  end
end
