require_relative "./doc_store/version"
require 'redis'

module DocStore
  class StoreError < StandardError  
  end

  class RecordNotFound < StandardError
  end

  class File
    attr_accessor :id, :email, :filename, :format, :service_id

    def initialize(hsh = {})
      @id = hsh[:id] || hsh['id']
      @email = hsh[:email] || hsh['email']
      @service_id = hsh[:service_id] || hsh['service_id']
      @format = hsh[:format] || hsh['format']
      @filename = hsh[:filename] || hsh['filename']
    end

    def to_h
      {id: id, email: email, filename: filename, format: format,
        service_id: service_id}
    end

    def destroy
      store.destroy(id)
      store.destroy(id + "_data")
    end

    def expire(delay = 1)
      store.expire(id, delay)
      store.expire(id + "_data", delay)
    end

    def save
      store.set(id, self.to_h.to_json)
    end

    def save_file(data)
      store.set(id + "_data", data.read)
    end

    def file
      store.get(id + "_data")
    end

    def self.load(l_id)
      string = DocStore::Store.new.get(l_id)
      if string.nil?
        raise DocStore::RecordNotFound, "#{l_id} file was not found"
      else
        DocStore::File.new(JSON.parse(string))
      end
    end

    private
    def store
      @store ||= DocStore::Store.new
    end
  end

  class Store
    def store
      @store ||= Redis.new host: redis_host,
                           port: redis_port
    end

    def set(id, data)
      store.set(id, data) == "OK" ? true : false
    end

    def get(id)
      if store.exists(id)
        store.get(id)
      else
        nil
      end
    end

    def destroy(id)
      return true if store.del(id) == 1
      return false
    end

    def expire(id, delay = 1)
      store.expire(id, delay)
    end

    private

    def redis_host
      ENV['DOCSTORE_REDIS_HOST'] || ENV['REDIS_HOST'] || 'localhost'
    end

    def redis_port
      ENV['DOCSTORE_REDIS_PORT'] || ENV['REDIS_PORT'] || 6379
    end
  end
end
