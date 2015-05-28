# desc "Explaining what the task does"
# task :onebox_api_doc do
#   # Task goes here
# end

namespace :onebox_api_doc do

  desc 'Install onebox_api_doc'
  task :install => :environment do
    # generate config file in initializer
    system 'rails g onebox_api_doc:install'
  end

end
