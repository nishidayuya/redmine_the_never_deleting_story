module RedmineTheNeverDeletingStory::ProjectPatch
  def deletable?(user = User.current)
    return super if RedmineTheNeverDeletingStory.deletable?(user)

    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting Project")
    return false
  end
end
