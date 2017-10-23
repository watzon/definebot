require "jennifer/adapter/postgres"
require "jennifer"

Jennifer::Config.configure do |conf|
  conf.host = "localhost"
  conf.user = "watzon"
  conf.password = "Pi31415926"
  conf.adapter = "postgres"
  conf.db = "definebot"
  conf.migration_files_path = "./db/migrations"
end