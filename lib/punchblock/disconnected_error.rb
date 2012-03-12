# encoding: utf-8

module Punchblock
  ##
  # This exception may be raised if the connection to the server is interrupted.
  class DisconnectedError < StandardError
    attr_accessor :cause, :message

    def initialize(cause = nil, message = nil)
      @cause, @message = cause, message
    end

    def to_s
      "#<#{self.class}: cause=#{cause.inspect} message=#{message.inspect}"
    end
    alias :inspect :to_s
  end
end
