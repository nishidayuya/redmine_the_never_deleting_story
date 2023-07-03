class RedmineTheNeverDeletingStory::Permission < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :expires_at, presence: true
end
