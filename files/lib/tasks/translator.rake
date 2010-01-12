require 'curb'

namespace :translator do
  desc "Pull last transations to the local yaml files"
  task :pull do
    host       = "translator.heroku.com"
    username   = FIXME
    password   = FIXME
    project_id = FIXME
    locales  = ['en', 'fr', 'es']
    
    locales.each do |locale|
      puts "Retrieving keys for locale #{locale}..."
      uri = "http://#{username}:#{password}@#{host}/projects/#{project_id}/exports/#{locale}.yml"
      c = Curl::Easy.perform(uri)
      File.open("#{RAILS_ROOT}/config/locales/#{locale}.yml", 'w') do |f|
        f.write c.body_str
      end
    end
    
    puts "Done."
  end
end