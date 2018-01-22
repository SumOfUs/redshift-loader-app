# Redshift Loader App
An app to incrementally load data from multiple PostgreSQL or MySQL tables into Redshift in order to keep a near-realtime replica of your production database for analytics. 

It can copy your schema from Postgres or MySQL to Redshift, perform an initial data load and then keep it up-to-date with changes as long as your tables are either insert-only with a sequential primary key, or have an `updated_at` column with is indexed.

It is written in Ruby, Padrino Framework and easy to deploy to Heroku.

# Getting started
Deploy the app and set environment variables. Run rake db:migrate and rake db:seed to set up the database and an admin user.

Log in to '/admin' with the credentials you just created.

Each pair of postgres database and redshift database is called a 'Job'. Each job has multiple tables which specify tables to be copied, primary_keys, updated_keys and whether the table is insert_only.

Create a new job, then specify a source_connection_string and destination_connection_string.

You can run `Job#setup` to extract all tables in the source database (public schema) and create them in the destination database (public schema). This will attempt to set `primary_key` and `updated_key` for each of the tables, but you will likely need to check and adjust details after you've run 'setup'.

Once you are ready for the syncing to begin, you can set the field active: true on the Job and it will start processing.

This will work for the intial data load and for incremental loading. If you have pre-existing data and you just want to sync incrementally, then you will need to update the `max_primary_key` and `max_updated_key` for each of the tables.

# How it works

Every job that has {active: true} set will be run once per minute. When the job is run it queues a TableWorker Sidekiq job for each of the tables attached to the job. The app uses `sidekiq-unique-jobs` to ensure that the same table is not being copied in two jobs simultaneously. This means jobs will be spread out to all Sidekiq workers and tables can be copied as soon as a worker is available. This is a change from earlier versions where tables would be copied sequentially and one slow table would cause the job to hang until it finished copying.

The TableWorker will look for new rows (since the last sync) and copy these into Redshift. By default this will just construct a SQL statement, but you will get better results by copying to S3 first. To do this enable the ENV variable `COPY_VIA_S3`, along with the AWS credentials and bucket name. (See `.example-env`)

It uses the environment variables `IMPORT_ROW_LIMIT` and `IMPORT_CHUNK_SIZE` to determine how much data to copy in one go, but if it doesn't reach the end of the table it will queue a new TableWorker job. The main constraint on this is RAM, so if you start getting memory errors, reduce the `IMPORT_ROW_LIMIT`.

# Copy modes

There are two copy modes which are fully operational and one, FullDataSync which is more experimental. These are controller by the 'table_copy_type' column on Tables,

- `InsertOnlyTable` = only copies new rows, don't update existing rows
- `UpdateAndInsertTable` = copies new rows, and update rows which have changed
- `FullSyncTable`: copies the full table on every run, swapping out the new and old data in a transaction (this is probably not suitable for large tables)

# Temporarily disabling table copies
You can temporarily disable a specific table copy by updating `table.disabled` to `true`. This column should be visible on ActivateAdmin.
