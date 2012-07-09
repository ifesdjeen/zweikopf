deps = File.join(File.dirname(__FILE__), "..", "deps")

Dir["#{deps}/\*.jar"].each do |jar|
  require jar
end

require 'java'
java_import "clojure.lang.RT"

require 'zweikopf'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir["spec/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.include Spec::Loader
end
