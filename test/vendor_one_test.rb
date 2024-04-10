require_relative './test_helper'
require_relative '../lib/vandelay/integrations/vendor_one'
require_relative '../lib/vandelay/integrations/vendor_two'
require_relative '../lib/vandelay/services/patient_records'
require 'json'

describe Vandelay::Services::PatientRecords do
  describe '#retrieve_record_for_patient' do
    let(:patient) { OpenStruct.new(id: 1, records_vendor: 'one', full_name: 'John Doe') }
    let(:cache) { Minitest::Mock.new }
    let(:vendor_one) { Minitest::Mock.new }
    let(:vendor_two) { Minitest::Mock.new }
    let(:patient_records) { Vandelay::Services::PatientRecords.new(patient, cache) }

    it 'returns the record from cache if available' do
      cache.expect(:check_key, '{"message":"cached record"}', ['retrieve_records_for_patient_1'])

      result = patient_records.retrieve_record_for_patient

      assert_equal({ 'message' => 'cached record' }, result)
    end

    it 'retrieves the record from the vendor and sets it in cache if not available' do
      skip 'Need to properly set test environment load path and database connection'

      cache.expect(:check_key, nil, ['retrieve_records_for_patient_1'])
      vendor_one.expect(:retrieve_record, { 'message' => 'vendor one record' }, [patient])
      cache.expect(:set_key, nil, ['retrieve_records_for_patient_1', '{"message":"vendor one record"}', { ex: 600 }])

      result = patient_records.retrieve_record_for_patient

      assert_equal({ 'message' => 'vendor one record' }, result)
    end

    it 'returns a message if no records vendor is found' do
      patient.stub(:records_vendor, nil) do
        result = patient_records.retrieve_record_for_patient

        assert_equal({ message: 'No records vendor found' }, result)
      end
    end
  end
end

describe Vandelay::Integrations::VendorOne do
  describe '#retrieve_record' do
    let(:vendor_one) { Vandelay::Integrations::VendorOne.new }

    it 'returns the patient record if found' do
      patient = OpenStruct.new(id: 1, full_name: 'John Doe')
      results = [
        { 'full_name' => 'John Doe', 'province' => 'Ontario', 'allergies' => 'None', 'recent_medical_visits' => 5 },
        { 'full_name' => 'Jane Smith', 'province' => 'Alberta', 'allergies' => 'Pollen', 'recent_medical_visits' => 3 }
      ]
      vendor_one.stub(:fetch_data, results) do
        result = vendor_one.retrieve_record(patient)

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
      vendor_one.stub(:fetch_data, results) do
        result = vendor_one.retrieve_record(patient)

        assert_equal({ message: 'Patient record not found' }, result)
      end
    end
  end
end
