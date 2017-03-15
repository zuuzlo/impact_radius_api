module ImpactRadiusAPI
  class APIResponse
    attr_reader :data, :request, :page, :num_pages, :page_size

    def initialize(response, resource)
      @request = response.request
      result = response["ImpactRadiusResponse"]
      @page = result[resource]["page"].to_i
      @num_pages = result[resource]["numpages"].to_i
      @page_size = result[resource]["pagesize"]
      @data = parse(result[resource][resource[0..-2]])
    end

    def all
      page = @page
      num_pages = @num_pages
      
      while num_pages > page
        uri = Addressable::URI.parse(request.uri)
        class_name = uri.path.match(/^\/[a-z]+\//i)[0].gsub("/","")
        params = uri.query_values
        params.merge!({ 'Page' => "#{page.to_i + 1}" })
        next_page_response =  ImpactRadiusAPI.const_get(class_name).new.request( "https://" + uri.authority + uri.path, params )
        page = next_page_response.page
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