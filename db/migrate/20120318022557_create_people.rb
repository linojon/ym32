class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :maiden
      t.string :prefix
      t.string :suffix
      t.string :gender
      t.date :birth_date
      t.date :death_date
      t.integer :death_hebrew_date_day
      t.integer :death_hebrew_date_month
      t.integer :death_hebrew_date_year
      t.boolean :death_after_sunset

      t.timestamps
    end
  end
end
