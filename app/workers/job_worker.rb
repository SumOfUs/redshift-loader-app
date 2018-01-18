class RunAllJobsWorker
  include Sidekiq::Worker
  
  sidekiq_options retry: false,
                  unique: :until_and_while_executing

  def perform
    ActiveRecord::Base.clear_active_connections!
    Job.where(active: true).each do |job|
      job.run
    end
  end
end