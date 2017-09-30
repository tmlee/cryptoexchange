require "bundler/setup"
require "cryptoexchange"
require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Add VCR to all tests
  # Usages
  # > VCR=all rspec spec # This will force all casettes to re-record
  # > rspec spec # This will save a casette if it does not exist, and reuse in the next
  config.around(:each) do |example|
    record_mode = ENV["VCR"] ? ENV["VCR"].to_sym : :once
    options = example.metadata[:vcr] || { :record => record_mode }
    if options[:record] == :skip
      VCR.turned_off(&example)
    else
      name = example.metadata[:full_description].split(/\s+/, 2).join('/').gsub(' ','_').gsub(/\./,'/').gsub(/[^\w\/]+/, '_').gsub(/\/$/, '')
      v = VCR.use_cassette(name, options, &example)
    end
  end
end
