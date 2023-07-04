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
