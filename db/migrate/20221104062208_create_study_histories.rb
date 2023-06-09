class CreateStudyHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :study_histories do |t|
      t.string :path, default: ''
      t.timestamps
    end
  end
end
