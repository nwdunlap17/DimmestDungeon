require_relative "bin/environment.rb"
require "sinatra/activerecord/rake"


desc 'starts a console'
task :run do
  #ActiveRecord::Base.logger = Logger.new(STDOUT)
  system('ruby bin/run.rb')
end

desc 'loads all tables'
task :reload do
  #ActiveRecord::Base.logger = Logger.new(STDOUT)
  system('rake db:rollback STEP=100')
  system('rake db:migrate')
  system('ruby bin/loadtables.rb')
end
