# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += ['dependencies/html5shiv.min.js']
Rails.application.config.assets.precompile += ['dependencies/respond.min.js']
Rails.application.config.assets.precompile += ['dependencies/jquery.treetable.js']
Rails.application.config.assets.precompile += ['admin/admin.js']
Rails.application.config.assets.precompile += ['ie_lt9.js']
Rails.application.config.assets.precompile += ['search_form.js']
Rails.application.config.assets.precompile += ['areas.js']
Rails.application.config.assets.precompile += ['events.js']
Rails.application.config.assets.precompile += ['holders.js']
Rails.application.config.assets.precompile += ['users.js']
Rails.application.config.assets.precompile += ['organizations.js']
Rails.application.config.assets.precompile += ['admin.css']
Rails.application.config.assets.precompile += ['email.css']
