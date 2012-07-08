deps = File.join(File.dirname(__FILE__), "..", "deps")

Dir["#{deps}/\*.jar"].each do |jar|
  require jar
end

require 'java'
java_import "clojure.lang.RT"

require 'zweikopf'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'
end
