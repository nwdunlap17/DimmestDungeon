require_relative "bin/environment.rb"
require "sinatra/activerecord/rake"


desc 'runs game'
task :run do
  #ActiveRecord::Base.logger = Logger.new(STDOUT)
  system('ruby bin/run.rb')
end

desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end

desc 'loads all tables'
task :reload do
  #ActiveRecord::Base.logger = Logger.new(STDOUT)
  system('rake db:rollback STEP=10')
  system('rake db:migrate')
  system('ruby bin/loadtables.rb')
end
