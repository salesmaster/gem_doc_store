require_relative '../test_helper'

describe DocStore::Store do
  subject { DocStore::Store.new }

  it "must have a store" do
    subject.must_respond_to :store
  end

  it "must respond to set" do
    subject.must_respond_to :set
  end

  it "must respond to get" do
    subject.must_respond_to :get
  end

  it "must respond to expire" do
    subject.must_respond_to :expire
  end

  it "must respond to destroy" do
    subject.must_respond_to :destroy
  end

  it "must have a redis connection active" do
    subject.store.must_be_instance_of Redis
  end

  it "must be able to write" do
    subject.set(SecureRandom.hex, Faker::Lorem.paragraph).must_be :==, true
  end
end