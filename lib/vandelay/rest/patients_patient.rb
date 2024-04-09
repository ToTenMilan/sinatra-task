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

        app.error do
          e = env['sinatra.error']
          json message: e.message
        end
      end
    end
  end
end
