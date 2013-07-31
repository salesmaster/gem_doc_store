require_relative '../test_helper'

describe DocStore do

  it "must be defined" do
    DocStore::VERSION.wont_be_nil
  end
end