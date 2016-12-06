class CreateComposerSources < ActiveRecord::Migration[5.0]
  def change
    create_table :composer_sources do |t|
      t.belongs_to :composer, foreign_key: true
      t.belongs_to :source, foreign_key: true
      t.string :era

      t.timestamps
    end
  end
end
