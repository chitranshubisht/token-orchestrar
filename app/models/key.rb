class Key < ApplicationRecord
    after_create :schedule_expiration

    private
    def schedule_expiration
        KeyExpirationJob.set(wait: 5.minutes).perform_later(id)
    end

    def unblock_key
        KeyUnblockJob.set(wait: 60.seconds).perform_later(id)
    end
end
