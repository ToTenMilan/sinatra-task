require_relative './test_helper'
# require_relative '../lib/vandelay/rest/patients_patient'
require 'json'
require 'rack/test'

describe 'Vandelay::REST::PatientsPatient' do
  include Rack::Test::Methods

  def app
    # Vandelay::REST::PatientsPatient
  end

  describe 'GET /patients/:id' do
    it 'returns a single patient' do
      skip 'Need to properly set test environment load path and database connection'

      # patient_id = 1
      # patient = OpenStruct.new(id: patient_id, full_name: 'John Doe')
      # Vandelay::REST::PatientsPatient.patients_srvc.stub(:retrieve_one, patient) do
      #   get "/patients/#{patient_id}"
      #   expect(last_response).to be_ok
      #   expect(JSON.parse(last_response.body)).to eq([patient])
      # end
    end
  end

  describe 'GET /patients/:patient_id/record' do
    it 'returns the patient record' do
      skip 'Need to properly set test environment load path and database connection'

      # patient_id = 1
      # patient = OpenStruct.new(id: patient_id, full_name: 'John Doe')
      # record = { 'full_name' => 'John Doe', 'province' => 'Ontario', 'allergies' => 'None', 'num_medical_visits' => 5 }
      # Vandelay::Services::Patients.new.stub(:retrieve_one, patient) do
      #   Vandelay::Services::PatientRecords.new.stub(:retrieve_record_for_patient, record) do
      #     get "/patients/#{patient_id}/record"
      #     expect(last_response).to be_ok
      #     expect(JSON.parse(last_response.body)).to eq(record)
      #   end
      # end
    end
  end

  describe 'Error handling' do
    it 'returns an error message' do
      skip 'Need to properly set test environment load path and database connection'

      # error_message = 'Something went wrong'
      # app.stub(:error, StandardError.new(error_message)) do
      #   get '/patients/1'
      #   expect(last_response).to be_ok
      #   expect(JSON.parse(last_response.body)).to eq({ 'message' => error_message })
      # end
    end
  end
end
