require_relative '../integrations/request_handler'

module Vandelay
  module Integrations
    class VendorTwo
      include RequestHandler

      def retrieve_record(patient)
        results = fetch_data('http://mock_api_two/auth_tokens/1', 'http://mock_api_two/records')
        api_patient = results.find { |r| r['full_name'] == patient.full_name }

        if api_patient
          {
            "patient_id": patient.id,
            "province": api_patient['province'],
            "allergies": api_patient['allergies'],
            "num_medical_visits": api_patient['recent_medical_visits']
          }
        else
          {
            message: 'Patient record not found'
          }
        end
      end
    end
  end
end
