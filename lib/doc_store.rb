require_relative "./doc_store/version"

module DocStore
  class File
    attr_accessor :id, :email, :service_id
    def initialize(hsh = {})
      @id = hsh[:id]
      @email = hsh[:email]
      @service_id = hsh[:service_id]
    end
  end
end
