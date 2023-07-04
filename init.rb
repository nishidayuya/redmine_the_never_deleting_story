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
