# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.minute, roles: [:export] do
  command "date > ~/cron-test-export.txt"
end

every 1.minute, roles: [:cron] do
  command "date > ~/cron-test-cron.txt"
end
#
# every 1.day, at: '00:00 am', roles: [:export] do
#   rake 'export:agendas'
#   rake 'export:organizations'
# end
#
# every 1.hour, at: '5:00 am', roles: [:cron] do
#   rake 'madrid:import'
#   rake 'events:update_event_status'
# end
#
# every 1.day, at: '6:00 am', roles: [:cron] do
#   rake 'import_organizations:associations'
#   rake 'import_organizations:federations'
# end