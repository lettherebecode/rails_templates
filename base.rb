#rails my_new_project_name -d mysql -m base.rb

if yes?("Do you want to use RSpec for testing?")
  plugin "rspec", :git => "git://github.com/dchelimsky/rspec.git"
  plugin "rspec-rails", :git => "git://github.com/dchelimsky/rspec-rails.git"
  generate :rspec
end

if yes?("Do you want to use cucumber for testing?")
  %w(development test).each do |env|
    gem "cucumber", :version => '0.1.16', :env => env
    gem "webrat", :version => '0.4.3', :env => env
    `sudo rake gems:install RAILS_ENV=#{env}`
  end
end

if yes?("Do you want user authentication?")
  list = `sudo gem list`
  run "sudo gem install nifty-generators" unless list =~ /nifty-generators/
  generate :nifty_authentication, "user"
end

%w(development test).each do |env|
  rake "db:create", :env => env
  rake "db:migrate", :env => env
end

run "rm public/index.html"
generate :controller, "welcome index"
route "map.root :controller => 'welcome'"

if yes?("Do you want to use git?")
  git :init
 
  run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
  run "cp config/database.yml config/example_database.yml"
 
  file ".gitignore", <<-END
  log/*.log
  tmp/**/*
  config/database.yml
  db/*.sqlite3
  END
 
  git :add => ".", :commit => "-m 'initial commit'"
end

