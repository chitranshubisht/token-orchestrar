class ApplicationJob < ActiveJob::Base
   retry_on ActiveRecord::Deadlocked

   discard_on ActiveJob::DeserializationError

   queue_as :default

   before_perform :log_job_start
   after_perform :log_job_end

   private

   def log_job_start
    Rails.logger.info "Starting the job: #{self.class.name} with arguments: #{arguments.inspect}"
   end

   def log_job_end
    Rails.logger.info "Finished the job: #{self.class.name} with arguments: #{arguments.inspect}"
   end
end