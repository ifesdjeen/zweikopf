require 'spec_helper'

describe :performance do

  #
  # Environment
  #

  let(:clj_hash) { load_fixture(:clj_hash1) }

  #
  # Examples
  #

  it "this spec simply shows performance, very roughly, please do your testing depending on your needs" do
    time_before = Time.now.to_f
    100000.times do |i|
      Zweikopf::Transformer.from_ruby({:a => i, :b => i})
    end
    puts "Ruby to Clojure, time elapsed: #{Time.now.to_f - time_before} seconds"

    time_before = Time.now.to_f
    100000.times do |i|
      Zweikopf::Transformer.from_clj(clj_hash)
    end

    puts "Clojure to Ruby, time elapsed: #{Time.now.to_f - time_before} seconds"
  end

end
