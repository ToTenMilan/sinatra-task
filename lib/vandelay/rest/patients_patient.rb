require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients/:id' do
          results = Vandelay::REST::PatientsPatient.patients_srvc.retrieve_one(params['id'])
          json([results])
        end

        app.get '/patients/:patient_id/record' do
          patient = Vandelay::Services::Patients.new.retrieve_one(params['patient_id'])
          results = Vandelay::Services::PatientRecords.new(patient).retrieve_record_for_patient
          json(results)
        end

        app.error do
          e = env['sinatra.error']
          json message: e.message
        end
      end

      # private

      # def self.records_vendor(patient)
      #   if patient.records_vendor == 'one'
      #     Vandelay::Integrations::VendorOne.new
      #   elsif patient.records_vendor == 'two'
      #     Vandelay::Integrations::VendorTwo.new
      #   else
      #     nil
      #   end
      # end
    end
  end
end
