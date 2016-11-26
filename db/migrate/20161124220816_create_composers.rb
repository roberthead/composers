class CreateComposers < ActiveRecord::Migration[5.0]
  def change
    create_table :composers do |t|
      t.string :page_name
      t.string :display_name
      t.string :primary_era
      t.integer :birth_year
      t.integer :death_year
      t.integer :wikipedia_page_length
      t.integer :google_results_count
      t.string :gender

      t.timestamps
    end
  end
end
