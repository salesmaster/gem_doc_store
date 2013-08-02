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

  it "must be able to save" do
    subject.must_respond_to :save
  end

  it "must be able to save_file" do
    subject.must_respond_to :save_file
  end

  it "must have a DocStore::Store store" do
    subject.send(:store).must_be_instance_of DocStore::Store
  end

  describe "saving meta data" do
    before do
      @id = SecureRandom.hex
      @email = Faker::Internet.email
      @service_id = SecureRandom.hex
      @meta_hash = {:id => @id, :email => @email, :service_id => @service_id}
      subject.save
    end

    subject { DocStore::File.new(@meta_hash) }

    it "must be save as not nil" do
      subject.send(:store).get(@id).must_be :!=, nil
    end

    it "must save data as json" do
      subject.send(:store).get(@id).must_be :==, @meta_hash.to_json
    end

    describe "loading from id" do
      before do
        @first_file = DocStore::File.new(@meta_hash)
        @first_file.save
        @reloaded = DocStore::File.load(@id)
      end

      it "must be save as not nil" do
        @first_file.send(:store).get(@id).must_be :!=, nil
      end

      it "must contain the correct data" do
        @first_file.send(:store).get(@id).must_be :==, @meta_hash.to_json
      end

      it "must have be a DocStore::File" do
        @reloaded.must_be_instance_of DocStore::File
      end

      it "must be the file we save" do
        @reloaded.id.must_be :==, @id
      end
    end
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
      subject.save_file(File.open(@file_name)).must_be :==, true
    end
    
    describe "checking save consequences" do
      before do
        subject.save_file(File.open(@file_name))
      end

      it "should have something in the file" do
        subject.file.must_be :!=, nil
      end

      it "should have the proper content" do
        subject.file.must_be :==, IO.read(@file_name)
      end

      after do
        subject.send(:store).destroy(subject.id)
      end
    end

    after do
      File.delete(@file_name)
    end
  end

end