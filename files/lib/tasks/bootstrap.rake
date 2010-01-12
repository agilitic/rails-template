namespace :app do
  desc "Bootstrap the database"
  task :bootstrap => :environment do
    
    if RAILS_ENV == 'development'
      Rake::Task[ "db:migrate:reset" ].invoke
      announce("Cleaning old attachments...")
      system "rm -rf #{RAILS_ROOT}/public/system/"
    end

    if RAILS_ENV == 'staging'
      AWS::S3::Base.establish_connection!(
        :access_key_id => S3_CONFIG['access_key_id'],
        :secret_access_key => S3_CONFIG['secret_access_key']
      )

      AWS::S3::Bucket.delete(S3_CONFIG['bucket'], :force => true)
      AWS::S3::Bucket.create(S3_CONFIG['bucket'])
    end 

    Rake::Task[ "app:seed" ].invoke

    puts "Bootstrapping the database..."
  end
end