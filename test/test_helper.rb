$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'solutions/sum'
require 'solutions/hello'
require 'solutions/checkout'
require 'solutions/app'
require 'solutions/multibuy_offer'

require 'minitest/autorun'

require 'logging'
Logging.logger.root.appenders = Logging.appenders.stdout
Logging.logger.root.level = :debug