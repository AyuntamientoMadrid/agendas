require 'support/helpers/session_helpers'
require 'support/helpers/js_helpers'
RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::JsHelpers, type: :feature
end
