module Vandelay
  module Integrations
    module RequestHandler
      def fetch_data(auth_endpoint, endpoint)
        uri = URI(auth_endpoint) # auth_tokens/1 is a path hardcoded by task author
        response = Net::HTTP.get_response(uri)
        json_response = JSON.parse(response.body)
        token = json_response['token']

        uri = URI(endpoint) # diff
        http = Net::HTTP.new(uri.host)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['Authorization'] = "Bearer #{token}"
        response = http.request(request)
        JSON.parse(response.body)
      end
    end
  end
end
