require 'spec_helper'

describe :performance do
  it "this spec simply shows performance" do
    time_before = Time.now.to_f
    100000.times do |i|
      Zweikopf::Hash.create({:a => i, :b => i})
    end
    puts "Time elapsed: #{Time.now.to_f - time_before} seconds"
  end
end
