module RedmineTheNeverDeletingStory::ApplicationControllerPatch
  def require_admin
    if %w[users destroy] == [params[:controller], params[:action]] &&
       !RedmineTheNeverDeletingStory.deletable?(User.current)
      logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting User")
      render_403
      return
    end

    return super
  end
end
