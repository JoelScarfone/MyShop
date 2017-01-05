trap('SIGINT') { puts "Exiting with Control-C"; exit }

#TODO: Add some tests
# Configure RSpec
RSpec.configure do |config|
    # Exit on first error found
    config.fail_fast = true
end