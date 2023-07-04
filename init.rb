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

module RedmineTheNeverDeletingStory::UndefDeleteMethods
  extend ActiveSupport::Concern

  INSTANCE_METHOD_NAMES = %i[
    delete
    destroy
    destroy!
  ]

  SINGLETON_METHOD_NAMES = %i[
    delete_all
    delete_by
    destroy_all
    destroy_by
  ]

  included do
    undef_method(*INSTANCE_METHOD_NAMES)

    singleton_class.class_eval do
      undef_method(*SINGLETON_METHOD_NAMES)
    end
  end
end

module RedmineTheNeverDeletingStory::IssuePatch
  def deletable?(user = User.current)
    return super if RedmineTheNeverDeletingStory.deletable?(user)

    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting Issue")
    return false
  end
end

module RedmineTheNeverDeletingStory::ProjectPatch
  def deletable?(user = User.current)
    return super if RedmineTheNeverDeletingStory.deletable?(user)

    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting Project")
    return false
  end
end

module RedmineTheNeverDeletingStory::UserPatch
  def own_account_deletable?
    return super if RedmineTheNeverDeletingStory.deletable?(User.current)

    logger.debug("[rtnds] #{__FILE__}:#{__LINE__} disabled deleting own User")
    return false
  end
end

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

class RedmineTheNeverDeletingStory::PermissionsController < ApplicationController
  layout 'admin'

  before_action :require_admin
  before_action :set_permission, only: %i[destroy]

  def index
    @permissions = RedmineTheNeverDeletingStory::Permission.where("expires_at > ?", Time.current)

    @permission = RedmineTheNeverDeletingStory::Permission.new
  end

  def create
    user = User.find(params[:permission][:user_id])
    expires_at = Time.current + params[:permission][:expire_after].to_i.seconds
    @permission = create_or_update_permission!(user:, expires_at:)

    redirect_to(
      redmine_the_never_deleting_story_permissions_path,
      notice: 'Permission was successfully created.',
    )
  end

  def destroy
    @permission.destroy!

    redirect_to(
      redmine_the_never_deleting_story_permissions_path,
      notice: "Permission was successfully destroyed.",
    )
  end

  private

  def set_permission
    @permission = RedmineTheNeverDeletingStory::Permission.find(params[:id])
  end

  def create_or_update_permission!(user:, expires_at:)
    permission = RedmineTheNeverDeletingStory::Permission.find_or_initialize_by(user:)
    permission.expires_at = expires_at
    permission.save!
  end
end

Redmine::Plugin.register :redmine_the_never_deleting_story do
  name 'Redmine The Never Deleting Story plugin'
  author 'Yuya.Nishida.'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://github.com/nishidayuya/redmine_the_never_deleting_story'
  author_url 'https://twitter.com/nishidayuya'

  menu :admin_menu, :redmine_the_never_deleting_story,
       {
         controller: "redmine_the_never_deleting_story/permissions",
         action: :index,
       },
       caption: "一時的な削除有効化",
       html: { class: "icon icon-settings" }

  Issue.prepend(RedmineTheNeverDeletingStory::IssuePatch)
  Project.prepend(RedmineTheNeverDeletingStory::ProjectPatch)
  User.prepend(RedmineTheNeverDeletingStory::UserPatch)
  ApplicationController.prepend(RedmineTheNeverDeletingStory::ApplicationControllerPatch)

  if RedmineTheNeverDeletingStory.full_power?
    Issue.include(RedmineTheNeverDeletingStory::UndefDeleteMethods)
    Project.include(RedmineTheNeverDeletingStory::UndefDeleteMethods)
    User.include(RedmineTheNeverDeletingStory::UndefDeleteMethods)
  end
end
