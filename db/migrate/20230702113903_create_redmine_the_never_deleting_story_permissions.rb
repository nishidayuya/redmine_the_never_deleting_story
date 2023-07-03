class CreateRedmineTheNeverDeletingStoryPermissions < ActiveRecord::Migration[6.1]
  def change
    create_table :rtnds_permissions do |t|
      t.references :user, foreign_key: true, null: false
      t.datetime :expires_at, null: false
      t.timestamps
    end
  end
end
