module RedmineTheNeverDeletingStory::IssuePatch
  def deletable?(user = User.current)
    return super if RedmineTheNeverDeletingStory.deletable?(user)

    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting Issue")
    return false
  end
end
