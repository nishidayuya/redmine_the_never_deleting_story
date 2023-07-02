module RedmineTheNeverDeletingStory
end

module RedmineTheNeverDeletingStory::IssuePatch
  def deletable?(user = User.current)
    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting Issue")
    return false
  end
end

module RedmineTheNeverDeletingStory::ProjectPatch
  def deletable?(user = User.current)
    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting Project")
    return false
  end
end

module RedmineTheNeverDeletingStory::UserPatch
  def own_account_deletable?
    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting own User")
    return false
  end
end

module RedmineTheNeverDeletingStory::ApplicationControllerPatch
  def require_admin
    if %w[users destroy] == [params[:controller], params[:action]]
      logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting User")
      render_403
      return
    end

    return super
  end
end

Redmine::Plugin.register :redmine_the_never_deleting_story do
  name 'Redmine The Never Deleting Story plugin'
  author 'Yuya.Nishida.'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/nishidayuya/redmine_the_never_deleting_story'
  author_url 'https://twitter.com/nishidayuya'

  Issue.prepend(RedmineTheNeverDeletingStory::IssuePatch)
  Project.prepend(RedmineTheNeverDeletingStory::ProjectPatch)
  User.prepend(RedmineTheNeverDeletingStory::UserPatch)
  ApplicationController.prepend(RedmineTheNeverDeletingStory::ApplicationControllerPatch)
end
