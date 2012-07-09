java_import 'clojure.lang.Compiler'

module Spec
  # Helper module for loading Clojure code
  module Loader

    # Loads fixture from the file located under spec/fixtures
    #
    # @param [String/Symbol] fixture_name: name of the fixture to load
    # @return [undefined]
    #
    # @api public
    def load_fixture(fixture_name)
      Compiler.load_file("spec/fixtures/#{fixture_name}.clj")
    end
  end
end
