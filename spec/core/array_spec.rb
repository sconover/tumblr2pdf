require "lib/core"
require "spec"

describe Array, "pluck" do
  it "plucks an attribute of an element of an array" do
    [1, 2, 3].pluck(:to_s).should == ["1", "2", "3"]
  end

  it "plucks many attributes" do
    [1, 2, 3].pluck(:to_s, :succ).should == [["1", 2], ["2", 3], ["3", 4]]
  end

  it "plucks successive" do
    [1, 2, 3].pluck([:to_s, :succ]).should == ["2", "3", "4"]
  end

  it "plucks hash" do
    [{"a"=>1}, {"a"=>2}, {"a"=>3}].pluck("a").should == [1, 2, 3]
  end

end
