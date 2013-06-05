# encoding: utf-8

module Punchblock
  class Event
    class Unjoined < Event
      register :unjoined, :core

      ##
      # @return [String] the call ID that was unjoined
      def call_id
        read_attr :'call-id'
      end

      ##
      # @param [String] other the call ID that was unjoined
      def call_id=(other)
        write_attr :'call-id', other
      end

      ##
      # @return [String] the mixer name that was unjoined
      def mixer_name
        read_attr :'mixer-name'
      end

      ##
      # @param [String] other the mixer name that was unjoined
      def mixer_name=(other)
        write_attr :'mixer-name', other
      end

      def inspect_attributes # :nodoc:
        [:call_id, :mixer_name] + super
      end

      # @return [String] the caller ID that was joined
      attribute :caller_id

      # @return [String] the channel name that was joined
      attribute :channel_name

      def has_call_reference?
        call_id.nil? || call_id == ''
      end
    end # Unjoined
  end
end
