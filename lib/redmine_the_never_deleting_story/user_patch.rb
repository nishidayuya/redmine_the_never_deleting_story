module RedmineTheNeverDeletingStory::UserPatch
  def own_account_deletable?
    return super if RedmineTheNeverDeletingStory.deletable?(User.current)

    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting own User")
    return false
  end
end
