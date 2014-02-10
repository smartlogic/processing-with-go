namespace :totals do
  task :generate => :environment do
    require 'database_cleaner'

    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean

    User.create(:name => "user")

    11.times do
      ActiveRecord::Base.connection.execute %{
        INSERT INTO users (name) (select name from users)
      }
    end

    10.times do
      ActiveRecord::Base.connection.execute %{
        INSERT INTO items (user_id, count) (select id, 10 from users)
      }
    end
  end

  desc "Run totals"
  task :run => [:generate, :environment] do
    user_ids = User.pluck(:id)

    Resque.redis.del("queue:totals")

    user_ids.each do |id|
      Resque.enqueue TotalsJob, id
    end

    pbar = ProgressBar.new("totals left", user_ids.count)
    while Total.count < user_ids.count
      sleep 1

      pbar.set(Total.count)
    end
    pbar.finish
  end
end
