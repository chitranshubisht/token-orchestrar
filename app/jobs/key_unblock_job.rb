class KeyUnblockJob < ApplicationJob
  queue_as :default

  def perform(key_id)
    key = Key.find_by(id: key_id)
    return unless key && key.blocked
    
    if key.blocked_at && key.blocked_at < 5.minute.ago
      key.update(blocked: false, blocked_at: nil)
    end
  end
end
