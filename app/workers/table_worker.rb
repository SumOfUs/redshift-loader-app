class TableWorker
  include Sidekiq::Worker
  
  sidekiq_options retry: false,
                  unique: :until_and_while_executing,
                  run_lock_expiration: 60 * 60 # If job takes more than 10 minutes, we'll abandon it
  
  def perform(table_id)
    p "I'm a starting to run on table #{table_id}"
    rows_copied = Table.find(table_id).copy_now

    # If the rows copied hit the row limit then it's possible there are more rows waiting, so we add another job
    if rows_copied == ENV['IMPORT_ROW_LIMIT'].to_i
      TableWorker.perform_async(table_id)
    end
  end
end
