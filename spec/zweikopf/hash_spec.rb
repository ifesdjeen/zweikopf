require 'spec_helper'

describe Zweikopf::Hash do
  describe :empty do
    let(:empty_hash) { load_fixture(:empty_hash) }

    it "returns empty clojure hash" do
      Zweikopf::Hash.empty.should eql empty_hash
    end
  end

  describe :create do


    context "when given a non-recursive hash structure" do

      #
      # Environment
      #

      let(:hash) { load_fixture(:clj_hash1) }

      #
      # Examples
      #

      it "creates a Clojure hash" do
        Zweikopf::Hash.create({:a => 1, :b => 2}).should eql hash
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
        Zweikopf::Hash.create({:a => 1, :b => {:c => 3, :d =>4}}).should eql hash
      end
    end
  end
end
