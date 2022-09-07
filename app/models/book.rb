class Book < ApplicationRecord
  enum reading_state: { rereading: 0, finish_reading: 1}
end
