require 'curses'
require 'pry'
require 'json'

require 'bundler/setup'
require 'rest-client'
require 'sinatra/activerecord'
require 'require_all'
require 'bundler'

require_relative '../lib/Menu.rb'
require_relative '../lib/Action.rb'
require_relative '../lib/Combatant.rb'
require_relative '../lib/CombatManager.rb'
require_relative '../lib/Adventurer.rb'
require_relative '../lib/Monster.rb'

Bundler.require

ActiveRecord::Base.establish_connection(
   :adapter => "sqlite3",
   :database => "./db/development.db"
)

require_all 'lib'

system 'printf "\e[8;41;123t"'
system "\n"