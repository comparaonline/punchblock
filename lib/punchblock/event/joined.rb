# encoding: utf-8

module Punchblock
  class Event
    class Joined < Event
      register :joined, :core

      # @return [String] the call ID that was joined
      attribute :call_uri

      # @return [String] the mixer name that was joined
      attribute :mixer_name

      # @return [String] the caller id that was joined
      attribute :caller_id

      # @return [String] other the channel name that was joined
      attribute :channel_name

      alias :call_id :call_uri

      def has_call_reference?
        call_id.nil? || call_id == ''
      end

    end
  end
end
