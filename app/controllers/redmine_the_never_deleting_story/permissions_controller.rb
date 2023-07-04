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
