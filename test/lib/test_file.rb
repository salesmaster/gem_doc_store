require_relative '../test_helper'

describe DocStore::File do
  subject { DocStore::File.new }

  it "must have an id" do
    subject.must_respond_to :id
  end

  it "must have an email" do
    subject.must_respond_to :email
  end

  it "must have a service id" do
    subject.must_respond_to :service_id
  end

  it "must have data" do
    subject.must_respond_to :data
  end

end