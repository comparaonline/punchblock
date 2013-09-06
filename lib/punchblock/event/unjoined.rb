# encoding: utf-8

module Punchblock
  class Event
    class Unjoined < Event
      register :unjoined, :core

      # @return [String] the call ID that was unjoined
      attribute :call_uri

      # @return [String] the mixer name that was unjoined
      attribute :mixer_name

      # @return [String] the caller id that was joined
      attribute :caller_id

      # @return [String] other the channel name that was joined
      attribute :channel_name

      alias :call_id :call_uri

      def has_call_reference?
        call_id.nil? || call_id == ''
      end

    end # Unjoined
  end
end
