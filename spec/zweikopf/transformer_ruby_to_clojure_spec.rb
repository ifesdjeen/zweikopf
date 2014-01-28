require 'spec_helper'
java_import 'clojure.lang.Util'

describe Zweikopf do
  describe :empty do
    let(:empty_hash) { load_fixture(:empty_hash) }

    it "returns empty clojure hash" do
      Zweikopf::Hash.empty.should eql empty_hash
    end
  end

  context "when given a ruby BigDecimal" do
    it "creates a java.math.Bigdecimal" do
      Zweikopf::Transformer.from_ruby(BigDecimal.new('12.34', 4)).should eql java.math.BigDecimal.new('12.34')
    end
  end

  context "when given a non-recursive hash structure" do

    #
    # Environment
    #

    let(:hash) { load_fixture(:clj_hash1) }

    #
    # Examples
    #

    it "creates a Clojure hash" do
      Zweikopf::Transformer.from_ruby({:a => 1, :b => 2}).should eql hash
    end
  end

  context "when given a recursive hash structure" do

    #
    # Environment
    #

    let(:hash) { load_fixture(:clj_deep_hash1) }

    #
    # Examples
    #

    it "creates a Clojure hash" do
      Zweikopf::Transformer.from_ruby({:a => 1, :b => {:c => 3, :d =>4}}).should eql hash
    end
  end

  context "given a data structure that requires custom transformations" do

    #
    # Environment
    #

    class CustomTransformedEntry
      def serializable_hash
        {:c => 3, :d => 4}
      end
    end

    let(:hash) { load_fixture(:clj_deep_hash1) }

    it "creates a Clojure hash with given block" do
      Zweikopf::Transformer.from_ruby({:a => 1, :b => CustomTransformedEntry.new }) do |v|
        if v.is_a?(CustomTransformedEntry)
          v.serializable_hash
        else
          v
        end
      end.should eql hash
    end

  end

  context "when given a clojure array" do

    #
    # Environment
    #

    let(:clj_array) { load_fixture(:clj_array1) }

    #
    # Examples
    #

    it "creates a Ruby array" do
      Zweikopf::Transformer.from_ruby([:a, 1, :b, 2, :c, 3]).should eql(clj_array)
    end
  end


  context "when given a hash that contains array that has a hash as an item" do

    #
    # Environment
    #

    let(:complex_hash) { load_fixture(:complex_hash) }

    #
    # Examples
    #

    it "creates a Ruby array" do
      Zweikopf::Transformer.from_ruby({:a => 1, :b => [2, 3, 4]}).should eql(complex_hash)
    end
  end

end
