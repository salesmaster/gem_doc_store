require_relative '../test_helper'

describe DocStore::File do
  let(:id) { SecureRandom.hex }
  let(:email) { Faker::Internet.email }
  let(:service_id) { SecureRandom.hex }
  let(:filename) { Faker::Lorem.words(1).join(' ') + ".txt" }
  let(:meta_hash) do
    {:id => id, :email => email, :filename => filename, :format => 'pdf',
      :service_id => service_id}
  end
  let(:file_path) { "/tmp/" + filename }

  subject { DocStore::File.new }

  it "must have an id" do
    subject.must_respond_to :id
  end

  it "must have an email" do
    subject.must_respond_to :email
  end

  it "must have a filename" do
    subject.must_respond_to :filename
  end

  it "must have a format" do
    subject.must_respond_to :format
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

  it "must have a to_h method" do
    subject.must_respond_to :to_h
  end

  it "must have a DocStore::Store store" do
    subject.send(:store).must_be_instance_of DocStore::Store
  end

  it "must return a proper hash" do
    subject.to_h.keys.must_be :==, [:id, :email, :filename, :format, :service_id]
  end

  describe "saving meta data" do
    before do
      subject.save
    end

    subject { DocStore::File.new(meta_hash) }

    it "must be save as not nil" do
      subject.send(:store).get(id).must_be :!=, nil
    end

    it "must save data as json" do
      subject.send(:store).get(id).must_be :==, meta_hash.to_json
    end

    describe "loading an incorrect id" do
      it "should return a DocStore::RecordNotFound exception" do
        proc do
          DocStore::File.load(SecureRandom.hex)
        end.must_raise DocStore::RecordNotFound
      end
    end

    describe "loading from id" do
      before do
        @first_file = DocStore::File.new(meta_hash)
        @first_file.save
        @reloaded = DocStore::File.load(id)
      end

      it "must be save as not nil" do
        @first_file.send(:store).get(id).must_be :!=, nil
      end

      it "must contain the correct data" do
        @first_file.send(:store).get(id).must_be :==, meta_hash.to_json
      end

      it "must have be a DocStore::File" do
        @reloaded.must_be_instance_of DocStore::File
      end

      it "must be the file we save" do
        @reloaded.id.must_be :==, id
      end
    end
  end

  describe "saving a file" do

    subject { DocStore::File.new(meta_hash) }

    before do
      File.open(file_path, "w") do |f|
        f.write Faker::Lorem.paragraphs
      end
    end

    it "must respond with true" do
      subject.save_file(File.open(file_path)).must_be :==, true
    end
    
    describe "checking save consequences" do
      before do
        subject.save
        subject.save_file(File.open(file_path))
      end

      it "should have something in the file" do
        subject.file.must_be :!=, nil
      end

      it "should have the proper content" do
        subject.file.must_be :==, IO.read(file_path)
      end

      describe "loading from id" do
        before do
          @reloaded = DocStore::File.load(id)
        end

        it "should have the propre file content" do
          @reloaded.file.must_be :==, IO.read(file_path)
        end
      end

      after do
        subject.send(:store).destroy(subject.id)
      end

    end

    after do
      File.delete(file_path)
    end
  end

end