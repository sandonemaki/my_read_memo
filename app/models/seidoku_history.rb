class SeidokuHistory < ApplicationRecord
  def self.set(new_path, book_id)
    if SeidokuHistory.count >= 100
      oldest_record = SeidokuHistory.order(:created_at).first
      oldest_record.destroy if oldest_record
    end
    seidoku_history = SeidokuHistory.new
    seidoku_history.path = new_path
    seidoku_history.book_id = book_id
    seidoku_history.save
  end
end
