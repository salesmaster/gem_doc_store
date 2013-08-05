require_relative "./doc_store/version"
require 'redis'

module DocStore
  class StoreError < StandardError  
  end

  class RecordNotFound < StandardError
  end

  class File
    attr_accessor :id, :email, :service_id

    def initialize(hsh = {})
      @id = hsh[:id] || hsh['id']
      @email = hsh[:email] || hsh['email']
      @service_id = hsh[:service_id] || hsh['service_id']
    end

    def save
      store.set(id, {:id => id, :email => email,
        :service_id => service_id}.to_json)
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
      @store ||= Redis.new(:host => ENV['REDIS_HOST'] || "localhost",
        :port => ENV['REDIS_PORT'] || 6379)
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

  end
end
