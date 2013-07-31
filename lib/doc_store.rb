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

    def data
      true
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
        raise StoreError, "#{id} could not be found"
      end
    end

    def destroy(id)
      return true if store.del(id) == 1
      return false
    end

    def expire(id)
    end

  end
end
