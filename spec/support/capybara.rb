Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app,
    timeout: 1.minute,
    # allows remote debugging by executing page.driver.debug
    inspector: true,
    # don't print console.log calls in console
    phantomjs_logger: File.open(File::NULL, "w"),
    # disable image loading
    phantomjs_options: ['--load-images=no', '--disk-cache=false'],
    #
    window_size: [1600, 4000],
    # disable js effects

  )
end

Capybara.javascript_driver = :poltergeist

Capybara.exact = true
