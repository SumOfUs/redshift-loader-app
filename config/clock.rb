require 'clockwork'
require 'clockwork/database_events'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'boot.rb'))

# Force reconnection and reaping
ActiveRecord::Base.establish_connection(
    ActiveRecord::Base.connection_config.merge({reconnect: true, reaping_frequency: 10})
    )

module Clockwork

  every(15.seconds, 'Run jobs') { RunAllJobsWorker.perform_async }

  error_handler do |error|
    Airbrake.notify(error)
  end

end
