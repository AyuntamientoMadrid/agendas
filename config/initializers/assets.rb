# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( dependencies/html5shiv.min.js )
Rails.application.config.assets.precompile += %w( dependencies/respond.min.js )
Rails.application.config.assets.precompile += %w( dependencies/jquery.treetable.js )
Rails.application.config.assets.precompile += %w( admin.css )
Rails.application.config.assets.precompile += %w( admin.js )

Rails.application.config.assets.precompile += %w( search_form.js )
Rails.application.config.assets.precompile += %w( admin_listings.js )
Rails.application.config.assets.precompile += %w( application_admin.css )
Rails.application.config.assets.precompile += %w( holders.js )
Rails.application.config.assets.precompile += %w( areas.js )
