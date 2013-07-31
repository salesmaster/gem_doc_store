require_relative "./doc_store/version"
require 'redis'

module DocStore
  class StoreError < StandardError  
  end

  class File
    attr_accessor :id, :email, :service_id

    def initialize(hsh = {})
      @id = hsh[:id]
      @email = hsh[:email]
      @service_id = hsh[:service_id]
    end

    def save(data)
      store.set(id, data.read)
    end

    def file
      store.get(id)
    end

    private
    def store
      @store = DocStore::Store.new
    end
  end

  class Store
    def store
      @store ||= Redis.new(:host => ENV['REDIS_HOST'] || "localhost",
        :port => ENV['REDIS_PORT'] || 6380)
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
