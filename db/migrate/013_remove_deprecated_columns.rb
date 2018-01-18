class RemoveDeprecatedColumns < ActiveRecord::Migration

  def change
    remove_column :tables, :insert_only
    remove_column :tables, :copy_mode
  end

end
