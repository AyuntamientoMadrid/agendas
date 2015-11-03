

task :import => :environment do
  #User.import(Rails.application.secrets.uweb_api_admins_key,'admin')
  User.import(Rails.application.secrets.uweb_api_users_key,'user')
  Holder.import(Rails.application.secrets.uweb_api_holders_key)
end
