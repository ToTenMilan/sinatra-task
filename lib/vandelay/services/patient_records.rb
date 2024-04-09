require 'redis-client'
require_relative '../util/cache'
require_relative '../integrations/vendor_one'
require_relative '../integrations/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      def initialize(patient, cache = nil, cache_expiry = nil)
        @patient = patient
        @vendor = records_vendor
        @cache = cache || Vandelay::Util::Cache.new
        @cache_expiry = cache_expiry || 600
      end

      def retrieve_record_for_patient
        return { message: 'No records vendor found'} if vendor.nil?

        key = "retrieve_records_for_patient_#{patient.id}"
        patient_record = cache.check_key(key)

        if patient_record
          p 'retrieving from cache...'
          JSON.parse(patient_record)
        else
          p 'setting cache...'
          result = vendor.retrieve_record(patient)
          cache.set_key(key, result.to_json, ex: cache_expiry)
          result
        end
      end

      private

      attr_reader :patient, :vendor, :cache, :cache_expiry

      def records_vendor
        if patient.records_vendor == 'one'
          @vendor = Vandelay::Integrations::VendorOne.new
        elsif patient.records_vendor == 'two'
          @vendor = Vandelay::Integrations::VendorTwo.new
        else
          nil
        end
      end
    end
  end
end
