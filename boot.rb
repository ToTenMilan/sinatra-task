require 'bundler/setup'

BASE_PATH = File.dirname(File.absolute_path(__FILE__))
$: << BASE_PATH + "/lib"

require 'net/http'
require 'vandelay'
require 'vandelay/util/db'
require 'vandelay/models'

# Vandelay::Util::DB.verify_connection! unless Vandelay::Util::DB.connection_verified?
