require 'spec_helper'
java_import 'clojure.lang.Compiler'

describe Zweikopf::Hash do

  def load_clojure_file(file)
    Compiler.load_file(file)
  end

  context :empty do
    let(:empty_hash) { load_clojure_file("spec/fixtures/empty_hash.clj") }

    it "returns empty clojure hash" do
      Zweikopf::Hash.empty.should eql empty_hash
    end
  end

  context :create do
    let(:hash) { load_clojure_file("spec/fixtures/clj_hash1.clj") }

    it "creates a Clojure hash" do
      Zweikopf::Hash.create({:a => 1, :b => 2}).should eql hash
    end
  end
end
