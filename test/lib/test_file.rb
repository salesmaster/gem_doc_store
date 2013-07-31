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

  it "must be able to save" do
    subject.must_respond_to :save
  end

  describe "saving a file" do

    subject { DocStore::File.new(id: SecureRandom.hex,
      email: Faker::Internet.email, service_id: SecureRandom.hex) }

    before do
      @file_name = "/tmp/" + Faker::Lorem.words(1).join(' ') + ".txt"
      File.open(@file_name, "w") do |f|
        f.write Faker::Lorem.paragraphs
      end
    end

    it "must respond with true" do
      subject.save(File.open(@file_name)).must_be :==, true
    end

    after do
      File.delete(@file_name)
    end
  end

end