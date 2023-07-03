namespace :redmine_the_never_deleting_story do
  resources :permissions, only: %i[index create destroy]
end
