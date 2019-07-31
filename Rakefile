require_relative "bin/environment.rb"
require "sinatra/activerecord/rake"


desc 'starts a console'
task :console do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  Pry.start
end
