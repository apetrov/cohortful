class BackgroundJob < ApplicationRecord
  after_create :notify_worker

  def notify_worker
    self.class.connection.execute("NOTIFY job_#{queue}")
  end
end
