namespace :app do
  desc "Seed the databass"
  task :seed => :environment do
    User.create do |u|
      u.username              = 'agilitic'
      u.password              = 'agilitic'
      u.password_confirmation = 'agilitic'
      u.email                 = 'info@agilic.com'
      u.admin                 = true
    end
  end
end