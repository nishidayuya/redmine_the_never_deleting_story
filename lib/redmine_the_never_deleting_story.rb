module RedmineTheNeverDeletingStory
  class << self
    def table_name_prefix
      return :rtnds_
    end

    def deletable?(user)
      return false if full_power?

      allowed = RedmineTheNeverDeletingStory::Permission.where(user:).where("expires_at > ?", Time.current).exists?
      return allowed
    end

    def full_power?
      return ENV["RTNDS_FULL_POWER"] == "1"
    end
  end
end
