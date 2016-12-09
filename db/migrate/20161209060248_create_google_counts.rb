class CreateGoogleCounts < ActiveRecord::Migration[5.0]
  class Composer < ActiveRecord::Base
  end

  def up
    create_table :google_counts do |t|
      t.integer :results_count
      t.belongs_to :composer, foreign_key: true

      t.timestamps
    end

    CreateGoogleCounts::Composer.find_each do |composer|
      GoogleCount.where(composer: composer, results_count: composer.google_results_count).first_or_create
    end
  end

  def down
    drop_table :google_counts
  end
end
