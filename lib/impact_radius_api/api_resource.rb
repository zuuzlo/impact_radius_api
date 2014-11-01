module ImpactRadiusAPI
  class APIResource
    include HTTParty

    def class_name
      self.class.name.split('::')[-1]
    end

    def base_path
      if self.class_name == "APIResource"
        raise NotImplementedError.new("APIResource is an abstract class. You should perform actions on its subclasses (i.e. Publisher)")
      end
      "/#{CGI.escape(class_name)}/"
    end

    def get(api_resource, params = {})
      @resource ||= self.xml_field(api_resource)
      unless auth_token ||= ImpactRadiusAPI.auth_token
        raise AuthenticationError.new(
          "No authentication token (AuthToken) provided. Set your API key using 'ImpactRadiusAPI.auth_token = <API-KEY>'. " +
          "You can retrieve your authentication token (AuthToken) from the Impact Radius web interface. " +
          "See http://dev.impactradius.com/display/api/Getting+Started for details."
        )
      end
      if auth_token =~ /\s/
        raise AuthenticationError.new(
          "Your authentication token (AuthToken) looks invalid. " +
          "Double-check your authentication token (AuthToken) at http://dev.impactradius.com/display/api/Getting+Started"
        )
      end

      unless account_sid ||= ImpactRadiusAPI.account_sid
        raise AuthenticationError.new(
          "No account_sid (AccountSid) provided. Set your account_sid (AccountSid) using 'ImpactRadiusAPI.account_sid = <AccountSid>'. " +
          "You can retrieve your account_sid (AccountSid) from the Impact Radius web interface. " +
          "See http://dev.impactradius.com/display/api/Getting+Started for details."
        )
      end

      if account_sid =~ /\s/ || account_sid.length != 34 || account_sid[0..1] != "IR"
        raise AuthenticationError.new(
          "Your account_sid (AccountSid) looks invalid. " +
          "Double-check your account_sid (AccountSid) at http://dev.impactradius.com/display/api/Getting+Started"
        )
      end

      raise ArgumentError, "Params must be a Hash; got #{params.class} instead" unless params.is_a? Hash

      #resource_url = ImpactRadiusAPI.api_base_url + base_path + api_resource
      resource_url = "https://" + account_sid + ":" + auth_token +"@" + ImpactRadiusAPI.api_base_uri + base_path + account_sid + "/" + api_resource
      request(resource_url, params)
    end

    def request(resource_url, params = {})
      timeout = ImpactRadiusAPI.api_timeout

      @resource ||= self.xml_field(resource_url.match(/\/[a-z]+(\?|\z)/i)[0].gsub("/","").gsub("?",""))
      
      begin
        response = self.class.get(resource_url, query: params, timeout: timeout)
      rescue Timeout::Error
        raise ConnectionError.new("Timeout error (#{timeout}s)")
      end
      process(response)
    end

    private

    def process(response)
      case response.code
      when 200, 201, 204
        APIResponse.new(response, @resource)
      when 400, 404
        raise InvalidRequestError.new(response["ImpactRadiusResponse"]["Message"], response.code)
      when 401
        raise AuthenticationError.new(response["ImpactRadiusResponse"]["Message"], response.code)
      else
        raise Error.new(response["ImpactRadiusResponse"]["Message"], response.code)
      end
    end
  end
end
