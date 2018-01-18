class UpdateColumnSize < ActiveRecord::Migration

  def change
    change_column :tables, :max_primary_key, :bigint
  end

end
