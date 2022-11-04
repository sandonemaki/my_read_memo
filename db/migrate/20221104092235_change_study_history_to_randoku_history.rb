class ChangeStudyHistoryToRandokuHistory < ActiveRecord::Migration[6.1]
  def change
    rename_table :study_histories, :randoku_histories
  end
end
