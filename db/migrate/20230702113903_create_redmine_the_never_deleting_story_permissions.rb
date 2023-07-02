class CreateRedmineTheNeverDeletingStoryPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :redmine_the_never_deleting_story_permissions do |t|
      t.references :user, foreign_key: true
      t.integer :operation
      t.datetime :expires_at
    end
    add_index :redmine_the_never_deleting_story_permissions, :user_id
  end
end
