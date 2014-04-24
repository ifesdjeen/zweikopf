require 'spec_helper'
require 'bigdecimal'
java_import 'clojure.lang.Util'

describe Zweikopf do
  context "when given a non-recursive hash structure" do

    #
    # Environment
    #

    let(:hash) { load_fixture(:clj_hash1) }

    #
    # Examples
    #

    it "creates a Clojure hash" do
      Zweikopf::Transformer.from_clj(hash).should eql({:a => 1, :b => 2})
    end
  end

  context "given a java.math.BigDecimal" do
    it "creates a ruby BigDecimal" do
      Zweikopf::Transformer.from_clj(java.math.BigDecimal.new("12.34")).should eql BigDecimal.new("12.34", 4)
     end
  end

  context "given a clojure.lang.Ratio" do
    it "creates a ruby Rational" do
      Zweikopf::Transformer.from_clj(Java::clojure.lang.Ratio.new(1,3)).should eql Rational(1,3)
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
      Zweikopf::Transformer.from_clj(hash).should eql({:a => 1, :b => {:c => 3, :d =>4}})
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
      Zweikopf::Transformer.from_clj(clj_array).should eql([:a, 1, :b, 2, :c, 3])
    end
  end

  context "when given a clojure lazy seq" do

    #
    # Environment
    #

    let(:clj_lazy_seq) { load_fixture(:clj_lazy_seq1) }

    #
    # Examples
    #

    it "creates a Ruby array" do
      Zweikopf::Transformer.from_clj(clj_lazy_seq).should eql([:a, 1, :b, 2, :c, 3])
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
      Zweikopf::Transformer.from_clj(complex_hash).should eql({:a => 1, :b => [2, 3, 4]})
    end
  end

end
