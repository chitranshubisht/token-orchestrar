class KeyExpirationJob < ApplicationJob
  queue_as :default

  def perform(key_id)
    key = Key.find_by(id: key_id)
    return unless key

    if key.keep_alive
      KeyExpirationJob.set(wait: 2.minutes).perform_later(key.id)
    else
      key.destroy
    end
  end
end
