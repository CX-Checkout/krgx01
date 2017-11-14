$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'solutions/sum'
require 'solutions/hello'
require 'solutions/app'

require 'minitest/autorun'

require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :debug
