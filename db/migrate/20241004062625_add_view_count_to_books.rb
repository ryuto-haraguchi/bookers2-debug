class AddViewCountToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :view_count, :integer, default: 0, null: false
  end
end
