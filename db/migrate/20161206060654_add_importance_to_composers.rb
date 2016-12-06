class AddImportanceToComposers < ActiveRecord::Migration[5.0]
  def change
    add_column :composers, :importance, :decimal, precision: 8, scale: 2
  end
end
