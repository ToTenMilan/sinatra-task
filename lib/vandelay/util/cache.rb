require 'redis'

module Vandelay
  module Util
    class Cache
      def initialize(cache = nil)
        @cache = cache || RedisClient.new(url: "redis://redis:6379")
      end

      def check_key(key)
        @cache.call('GET', key)
      end

      def set_key(key, data, options = {})
        @cache.call('SET', key, data, options)
      end
    end
  end
end
