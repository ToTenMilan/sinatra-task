module Vandelay
  module Integrations
    class VendorOne
      def initialize

      end

      def retrieve_record(patient)
        uri = URI("http://mock_api_one/auth/#{patient.vendor_id}") # diff
        response = Net::HTTP.get_response(uri)
        json_response = JSON.parse(response.body)
        token = json_response['token']

        uri = URI("http://mock_api_one/patients") # diff
        http = Net::HTTP.new(uri.host)
        request = Net::HTTP::Get.new(uri.request_uri)
        request['Authorization'] = "Bearer #{token}"
        response = http.request(request)
        results = JSON.parse(response.body)
        api_patient = results.find { |r| r['full_name'] == patient.full_name }

        {
          "patient_id": patient.id,
          "province": api_patient['province'],
          "allergies": api_patient['allergies'],
          "num_medical_visits": api_patient['recent_medical_visits']
        }
      end
    end
  end
end
