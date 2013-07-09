# encoding: utf-8

module Punchblock
  class Event
    class Joined < Event
      register :joined, :core

      ##
      # @return [String] the call ID that was joined
      def call_id
        read_attr :'call-id'
      end

      ##
      # @param [String] other the call ID that was joined
      def call_id=(other)
        write_attr :'call-id', other
      end

      ##
      # @return [String] the mixer name that was joined
      def mixer_name
        read_attr :'mixer-name'
      end

      ##
      # @param [String] other the mixer name that was joined
      def mixer_name=(other)
        write_attr :'mixer-name', other
      end

      def inspect_attributes # :nodoc:
        [:call_id, :mixer_name] + super
      end

      ##
      # @return [String] the caller id that was joined
      def caller_id
        read_attr :'caller-id'
      end

      ##
      # @param [String] other the caller id that was joined
      def caller_id=(other)
        write_attr :'caller-id', other
      end

      ##
      # @return [String] the channel name that was joined
      def channel_name
        read_attr :'channel-name'
      end

      ##
      # @param [String] other the channel name that was joined
      def channel_name=(other)
        write_attr :'channel-name', other
      end

      def has_call_reference?
        call_id.nil? || call_id == ''
      end
    end # Joined
  end
end
