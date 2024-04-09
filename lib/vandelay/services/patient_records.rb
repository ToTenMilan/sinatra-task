require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'
module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient_id)
        patient = Vandelay::Services::Patients.new.retrieve_one(patient_id)

        records_vendor = patient.records_vendor
        vendor_id = patient.vendor_id
        if records_vendor == 'one'
          vendor_one = Vandelay::Integrations::VendorOne.new
          vendor_one.retrieve_record(patient)
        elsif records_vendor == 'two'
          vendor_two = Vandelay::Integrations::VendorTwo.new
          vendor_two.retrieve_record(patient)
        else
          { message: 'No records vendor found'}
        end
      end
    end
  end
end
