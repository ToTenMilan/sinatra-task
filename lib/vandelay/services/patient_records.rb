require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'
require 'redis-client'

module Vandelay
  module Services
    class PatientRecords
      def retrieve_record_for_patient(patient_id)
        patient = Vandelay::Services::Patients.new.retrieve_one(patient_id)

        records_vendor = patient.records_vendor
        vendor_id = patient.vendor_id

        # move too cache later
        redis = RedisClient.new(url: "redis://redis:6379")
        patient_record = redis.call('GET', "retrieve_records_for_patient_#{patient_id}")



        if patient_record
          p 'retrieving from cache...'
          JSON.parse(patient_record)
        else
          if records_vendor == 'one'
            p 'retrieveing object: vendor ONE...'
            vendor_one = Vandelay::Integrations::VendorOne.new
            p 'sestting cache...'
            redis.call('SET', "retrieve_records_for_patient_#{patient_id}", vendor_one.retrieve_record(patient).to_json, ex: 600)
            p 'cache set'
            vendor_one.retrieve_record(patient)
          elsif records_vendor == 'two'
            p 'retrieveing object: vendor TWO...'
            vendor_two = Vandelay::Integrations::VendorTwo.new
            p 'setting cache...'
            redis.call('SET', "retrieve_records_for_patient_#{patient_id}", vendor_one.retrieve_record(patient).to_json, ex: 600)
            p 'cache set'
            vendor_two.retrieve_record(patient)
          else
            { message: 'No records vendor found'}
          end
        end
      end
    end
  end
end
