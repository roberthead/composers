class AddSimplifiedNameToComposers < ActiveRecord::Migration[5.0]
  def change
    add_column :composers, :transliterated_name, :string
    add_column :composers, :transliterated_short_name, :string
  end
end
