class RemoveRunAsSeparateJob < ActiveRecord::Migration

  def change
    drop_table :delayed_jobs
    remove_column :tables, :run_as_separate_job
  end

end
