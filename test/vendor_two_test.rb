require_relative './test_helper'
require_relative '../lib/vandelay/integrations/vendor_two'
require 'json'

describe Vandelay::Integrations::VendorTwo do
  describe '#retrieve_record' do
    let(:vendor_two) { Vandelay::Integrations::VendorTwo.new }

    it 'returns the patient record if found' do
      patient = OpenStruct.new(id: 1, full_name: 'John Doe')
      results = [
        { 'full_name' => 'John Doe', 'province' => 'Ontario', 'allergies' => 'None', 'recent_medical_visits' => 5 },
        { 'full_name' => 'Jane Smith', 'province' => 'Alberta', 'allergies' => 'Pollen', 'recent_medical_visits' => 3 }
      ]
      vendor_two.stub(:fetch_data, results) do
        result = vendor_two.retrieve_record(patient)

        assert_equal(
          {
            "patient_id": 1,
            "province": "Ontario",
            "allergies": "None",
            "num_medical_visits": 5
          },
          result
        )
      end
    end

    it 'returns a message if patient record not found' do
      patient = OpenStruct.new(id: 1, full_name: 'John Doe')
      results = [
        { 'full_name' => 'Jane Smith', 'province' => 'Alberta', 'allergies' => 'Pollen', 'recent_medical_visits' => 3 }
      ]
      vendor_two.stub(:fetch_data, results) do
        result = vendor_two.retrieve_record(patient)

        assert_equal({ message: 'Patient record not found' }, result)
      end
    end
  end
end
