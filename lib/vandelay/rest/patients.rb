require 'vandelay/services/patients'

module Vandelay
  module REST
    module Patients
      def self.patients_srvc
        @patients_srvc ||= Vandelay::Services::Patients.new
      end

      def self.registered(app)
        app.get '/patients' do
          results = Vandelay::REST::Patients.patients_srvc.retrieve_all
          json(results)
        end

        app.error do
          e = env['sinatra.error']
          json message: e.message
        end
      end
    end
  end
end
