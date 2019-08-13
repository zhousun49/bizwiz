namespace :graphs do
  desc "TODO"
  task delete_1_hour_old: :environment do
    Graph.where(created_at: 1.second.ago).destroy_all
  end
end
