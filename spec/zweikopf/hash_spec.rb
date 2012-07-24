require 'spec_helper'
java_import 'clojure.lang.Util'
describe Zweikopf::Hash do

  describe :from_ruby do

    describe :array do

      context "when given an empty array" do
        let(:empty_vector) { load_fixture(:clj_empty_vector)}
        it "created an empty Clojure vector" do
          Zweikopf::Array.from_ruby([]).should eql empty_vector
        end
      end

      context "when given an array" do
        let(:vector) { load_fixture(:clj_vector)}
        it "creates a Clojure vector" do
          Zweikopf::Array.from_ruby([:a, 1, :b, 2, :c, 3]).should eql vector
        end
      end

      context "when given a nested array" do
        let(:nested_vector) { load_fixture(:clj_nested_vector)}
        it "creates a nested Clojure vector" do
          Zweikopf::Array.from_ruby([:a, 1, :b, [2, :c, 3], :d]).should eql nested_vector
        end
      end
    end

    describe :hash do

      context "given an empty hash" do
        let(:empty_hash) { load_fixture(:clj_empty_hash) }

        it "returns empty clojure hash" do
          Zweikopf::Hash.empty.should eql empty_hash
        end
      end

      context "when given a non-recursive hash structure" do
        let(:hash) { load_fixture(:clj_hash1) }
        it "creates a Clojure hash" do
          Zweikopf::Hash.from_ruby({:a => 1, :b => 2}).should eql hash
        end
      end

      context "when given a recursive hash structure" do
        let(:hash) { load_fixture(:clj_deep_hash1) }
        it "creates a Clojure hash" do
          Zweikopf::Hash.from_ruby({:a => 1, :b => {:c => 3, :d =>4}}).should eql hash
        end
      end

      context "given a data structure that requires custom transformations" do
        class CustomTransformedEntry
          def serializable_hash
            {:c => 3, :d => 4}
          end
        end

        let(:hash) { load_fixture(:clj_deep_hash1) }

        it "creates a Clojure hash with given block" do
          Zweikopf::Hash.from_ruby({:a => 1, :b => CustomTransformedEntry.new }) do |v|
            if v.is_a?(CustomTransformedEntry)
              v.serializable_hash
            else
              v
            end
          end.should eql hash
        end
      end

    end
  end

  describe :from_clj do

    describe :hash do

      context "given an empty clojure hash" do
        let(:clj_empty_hash) { load_fixture(:clj_empty_hash) }
        it "creates an empty Ruby Hash" do
          Zweikopf::Hash.from_clj(clj_empty_hash).should eql({})
        end
      end

      context "given a non-recursive clojure hash structure" do
        let(:clj_hash) { load_fixture(:clj_hash1) }
        it "creates a Ruby hash" do
          Zweikopf::Hash.from_clj(clj_hash).should eql({:a => 1, :b => 2})
        end
      end

      context "when given a recursive hash structure" do
        let(:clj_hash) { load_fixture(:clj_deep_hash1) }
        it "creates a Clojure hash" do
          Zweikopf::Hash.from_clj(clj_hash).should eql({:a => 1, :b => {:c => 3, :d =>4}})
        end
      end

    end

    describe :vector do

      context "when given an empty clojure vector" do
        let(:clj_empty_vector) { load_fixture(:clj_empty_vector) }
        it "created an empty Ruby array" do
          Zweikopf::Array.from_clj(clj_empty_vector).should eql([])
        end
      end

      context "when given a clojure vector" do
        let(:clj_vector) { load_fixture(:clj_vector) }
        it "creates a Ruby array" do
          Zweikopf::Array.from_clj(clj_vector).should eql([:a, 1, :b, 2, :c, 3])
        end
      end

      context "when given a nested clojure vector" do
        let(:clj_nested_vector) { load_fixture(:clj_nested_vector) }
        it "creates a nested Ruby array" do
          Zweikopf::Array.from_clj(clj_nested_vector).should eql([:a, 1, :b, [2, :c, 3], :d])
        end
      end

    end

  end
end
