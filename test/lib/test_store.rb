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

  describe "the key doesn't exist yet" do
    it "must return nil on get" do
      subject.get(@key).must_be :==, nil
    end

    it "must return true on delete" do
      subject.destroy(@key).must_be :==, false
    end

    it "must return false on expire" do
      subject.expire(@key).must_be :==, nil
    end
  end

  describe "actions after writing" do
    before do
      @key = SecureRandom.hex
      @value = Faker::Lorem.paragraph
      subject.set(@key, @value)
    end

    it "must be able to get" do
      subject.get(@key).must_be :==, @value
    end

    it "must be able to delete" do
      subject.destroy(@key).must_be :==, true
    end

    it "must be able to expire" do
      subject.expire(@key).must_be :==, true
    end

    describe "actions after expiring" do
      before do
        subject.expire(@key)
        sleep 1
      end

      it "must have expired the key" do
        subject.get(@key).must_be :==, nil
      end
    end

    describe "actions after deleting" do
      before do
        subject.destroy(@key)
      end

      it "must return nil on get" do
        subject.get(@key).must_be :==, nil
      end
    end

    after do
      subject.destroy(@key)
    end
  end
end