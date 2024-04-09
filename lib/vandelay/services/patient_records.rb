require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'
require 'redis-client'

module Vandelay
  module Services
    class PatientRecords
      def initialize(patient)
        @patient = patient
        @vendor = records_vendor
      end

      def retrieve_record_for_patient
        return { message: 'No records vendor found'} if @vendor.nil?

        redis = RedisClient.new(url: "redis://redis:6379")
        patient_record = redis.call('GET', "retrieve_records_for_patient_#{@patient.id}")

        if patient_record
          p 'retrieving from cache...'
          JSON.parse(patient_record)
        else
          p 'setting cache...'
          result = @vendor.retrieve_record(@patient)
          redis.call('SET', "retrieve_records_for_patient_#{@patient.id}", result.to_json, ex: 600)
          result
        end
      end

      private

      def records_vendor
        if @patient.records_vendor == 'one'
          @vendor = Vandelay::Integrations::VendorOne.new
        elsif @patient.records_vendor == 'two'
          @vendor = Vandelay::Integrations::VendorTwo.new
        else
          nil
        end
      end
    end
  end
end
