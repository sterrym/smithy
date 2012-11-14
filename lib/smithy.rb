require "smithy/engine"
# libraries
require 'smithy/dependencies'
# config
require 'smithy/logger'
require 'smithy/dragonfly'
require 'smithy/liquid'

module Smithy

  def self.log(*args)
    level   = args.size == 1 ? 'info' : args.first
    message = args.size == 1 ? args.first : args.last
    ::Smithy::Logger.send(level.to_sym, message)
  end

end
