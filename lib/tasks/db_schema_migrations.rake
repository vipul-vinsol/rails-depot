require 'optparse'

namespace :db do
  desc "Prints the migrated versions"
  task :schema_migrations => :environment do
    puts ActiveRecord::Base.connection.select_values(
      'select version from schema_migrations order by version' )
  end

  desc "Update role of user to admin who's email is provided"
  task :update_role, [:email] => :environment do |t, args|
    if args[:email]
      user = User.find_by(email: args[:email])
      user.role = 'admin'
      user.save
      puts "Completed"
    else
      puts "Email must be provided"
    end
    exit
  end
end