class AddActiveFlag < ActiveRecord::Migration

  def change
    add_column :jobs, :active, :boolean , null: false, default: false

    drop_table :clockwork_events
  end

end
