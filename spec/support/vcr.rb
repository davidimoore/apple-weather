require "vcr"
VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.ignore_localhost = true
end