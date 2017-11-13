# Capybara.asset_host = 'http://localhost:3000'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
    timeout: 1.minute,
    inspector: true, # allows remote debugging by executing page.driver.debug
    phantomjs_logger: File.open(File::NULL, "w"), # don't print console.log calls in console
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    extensions: [File.expand_path("../phantomjs_ext/disable_js_fx.js", __FILE__)] # disable js effects
  )
end

Capybara.javascript_driver = :poltergeist

Capybara.exact = true