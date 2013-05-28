# encoding: utf-8

module Punchblock
  class Event
    class End < Event
      register :end, :core

      include HasHeaders

      attr_accessor :reason

      def inherit(xml_node)
        self.reason = xml_node.at_xpath('*').name.to_sym
        super
      end

      def inspect_attributes # :nodoc:
        [:reason] + super
      end
    end # End
  end
end # Punchblock
