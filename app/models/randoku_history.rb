class RandokuHistory < ApplicationRecord
  def self.set(new_path, book_id)
    if RandokuHistory.count >= 100
      oldest_record = RandokuHistory.order(:created_at).first
      oldest_record.destroy if oldest_record
    end
    randoku_history = RandokuHistory.new
    randoku_history.path = new_path
    randoku_history.book_id = book_id
    randoku_history.save
  end
end
