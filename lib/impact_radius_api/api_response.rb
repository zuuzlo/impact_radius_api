module ImpactRadiusAPI
  class APIResponse
    attr_reader :meta, :data, :request

    def initialize(response, resource)
      @request = response.request
      result = response["ImpactRadiusResponse"]
      require 'pry'; binding.pry
      @data = parse(result[resource][resource[0..-2]])
    end

    def all
      while meta.pagination.next
        uri = Addressable::URI.parse(meta.pagination.next.href)
        next_page_response = EBayEnterpriseAffiliateNetwork::Publisher.new.request(uri.origin + uri.path, uri.query_values)
        @meta = next_page_response.meta
        @data += next_page_response.data
      end
      @data
    end

    private

    def parse(raw_data)
      data = []
      data = [RecursiveOpenStruct.new(raw_data)] if raw_data.is_a?(Hash) # If we got exactly one result, put it in an array.
      raw_data.each { |i| data << RecursiveOpenStruct.new(i) } if raw_data.is_a?(Array)
      data
    end
  end
end